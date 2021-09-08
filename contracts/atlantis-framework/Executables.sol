// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @author  @vonnie610 (Twitter) @Nicca42 (GitHub)
 * @title   Executable Tokens
 * @notice  This contract allows you to create a non-fungible token for an 
 *          executable.
 */
contract Executables is ERC721 {
    // Identifier of token
    bytes32 public constant IDENTIFIER = bytes32(keccak256("EXECUTABLES"));
    // Executable information 
    struct Executable {
        address[] targets;
        uint256[] values;
        // Only the function signatures
        string[] functionSignatures;
        // The encoded function call with signature (what gets executed)
        bytes[] callsData;
        address creator;
        // The total amount of native tokens needed to execute
        uint256 valueTotal;
        string description;
    }
    // ID to the token to the executable details 
    mapping(uint256 => Executable) private executables_;

    //--------------------------------------------------------------------------
    // CONSTRUCTOR

    constructor(
        string memory _name, 
        string memory _symbol
    ) ERC721(_name, _symbol)
    {}

    //--------------------------------------------------------------------------
    // VIEW & PURE

    /**
     * @param   _id The ID of the token
     * @return  address[] Array of target addresses. I.e The contract getting 
     *          called.
     * @return  uint256[] Array of native token values for calls. I.e How much
     *          ETH to send with a call. Note that this is not the gas amount.
     * @return  bytes[] Array of calldata. This consists of the function 
     *          signature as well as the encoded parameters. 
     */
    function viewExecutable(
        uint256 _id
    )
        public 
        view 
        returns(
            address[] memory,
            uint256[] memory,
            bytes[] memory
        )
    {
        return (
            executables_[_id].targets,
            executables_[_id].values,
            executables_[_id].callsData
        );
    }

    /**
     * @param   _targets Array of target addresses. 
     * @param   _values Native token values to send with each call.
     * @param   _functionSignatures Function signatures to call on the targets.
     * @param   _encodedParameters The encoded parameters for each function 
     *          call.
     * @param   _description A general description for the executable.
     * @return  uint256 The ID for the executable. 
     */
    function hashExecutable(
        address[] calldata _targets,
        uint256[] calldata _values,
        string[] calldata _functionSignatures,
        bytes[] calldata _encodedParameters,
        string calldata _description
    ) public pure returns (uint256) {
        return uint256(keccak256(abi.encode(
            _targets, 
            _values, 
            _functionSignatures,
            _encodedParameters, 
            _description
        )));
    }

    //--------------------------------------------------------------------------
    // PUBLIC

    /**
     * @param    _targets Array of target addresses. 
     * @param   _values Native token values to send with each call.
     * @param   _functionSignatures Function signatures to call on the targets.
     * @param   _encodedParameters The encoded parameters for each function 
     *          call.
     * @param   _description A general description for the executable.
     * @return  uint256 The ID for the executable. 
     * @notice  This function will encode the passed function signatures and 
     *          function parameters to create the calldata. If your function
     *          parameters or signatures are incorrect, corrupted or in the 
     *          wrong order, the created executable will always fail on execute.
     *          We highly recommend simulating your calls before creating the
     *          executable.
     */
    function createExecutable(
        address[] calldata _targets,
        uint256[] calldata _values,
        string[] calldata _functionSignatures,
        bytes[] calldata _encodedParameters,
        string calldata _description
    )
        public 
        returns(uint256)
    {
        require(
            _targets.length == _values.length && 
            _targets.length == _encodedParameters.length,
            "Executor: Invalid array lengths"
        );

        uint256 id = hashExecutable(
            _targets, 
            _values, 
            _functionSignatures, 
            _encodedParameters, 
            _description
        );

        require(
            executables_[id].creator == address(0),
            "Executor: executable exists"
        );
        // Counter for map native token cost.
        uint256 callValueTotal;
        // Storage for encoded function calls.
        bytes[] memory generatedCallData = new bytes[](_targets.length);

        for (uint256 i = 0; i < _targets.length; i++) {
            // Encoding function calls (signature and data)
            generatedCallData[i] = abi.encodePacked(
                bytes4(keccak256(bytes(_functionSignatures[i]))), 
                _encodedParameters[i]
            );
            callValueTotal += _values[i];
        }

        executables_[id] = Executable({
            targets: _targets,
            values: _values,
            functionSignatures: _functionSignatures,
            callsData: generatedCallData,
            creator: msg.sender,
            valueTotal: callValueTotal,
            description: _description
        });

        _mint(msg.sender, id);

        return id;
    }
}
