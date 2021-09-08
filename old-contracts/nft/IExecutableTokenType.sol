// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./IExternalTokenTypeImplementation.sol";

/**
 * @title   An extendable type of implementation, for an executable token type.
 *          Extends the `IExternalTokenTypeImplementation` interface.
 * @author  Veronica Coutts <hello@vee.dev> @vonnie610 (twitter)
 * @notice  A standard for an executable token type, specifying how the
 *          executable data is formatted and accessed.
 */
interface IExecutableTokenType is IExternalTokenTypeImplementation {
    /**
     * @return  implementationType The implementation type. For the Executable
     *          type it should return:
     *          `bytes32(keccak256(abi.encode("EXECUTABLE")));`
     */
    function getImplementationType()
        external
        view
        override
        returns (bytes32 implementationType);

    /**
     * @param   _tokenId The ID of the specific token.
     * @return  targets Array of addresses to call for execution.
     * @return  callData The encoded transaction calls (function sig + encoded
     *          parameters) to be called on each target address.
     * @return  callValues Array of native token values to pass with each target
     *          call.
     * @notice  MUST revert if the `targets` and `callData` array are not equal
     *              in length.
     *          MUST require that `callValues` array is either equal in length
     *              to `targets` and `callData` OR is of length 1, and the same
     *              value will then be used for every call.
     */
    function getExecutables(uint256 _tokenId)
        external
        view
        returns (
            address[] memory targets,
            bytes[] memory callData,
            uint256[] memory callValues
        );
}