// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./IExternalTokenTypeImplementation.sol";

/**
 * @title   An extendable type of implementation, for an ownership token type.
 *          Extends the `IExternalTokenTypeImplementation` interface.
 * @author  Veronica Coutts <hello@vee.dev> @vonnie610 (twitter)
 * @notice  A standard for an ownership token, that holds ownership rights to an
 *          owned contract.
 */
interface ITokenizedOwnershipTokenType is IExternalTokenTypeImplementation {
    /**
     * @return  implementationType The implementation type. For the tokenized
     *          ownership type it should return:
     *          `bytes32(keccak256(abi.encode("TOKENIZED_OWNERSHIP")));`
     */
    function getImplementationType()
        external
        view
        override
        returns (bytes32 implementationType);

    /**
     * @param   _tokenId The ID of the specific token.
     * @return  ownedContract The address of the owned contract.
     * @notice  Owned contracts MUST implement the `TokenOwnedContract`
     *              interface, and return the token type identifier of this 
     *              token on the base implementation when 
     *              `isTokenOwnedContract()` is called.
     */
    function getOwnedContract(uint256 _tokenId)
        external
        view
        returns (address ownedContract);

    /**
     * @param   _type Type of token.
     * @param   _owner Address being checked.
     * @return  tokenIds Array of all token IDs of the token type that the owner
     *          owns.
     * @notice  OPTIONAL This function is optional to implement.
     */
    function getTokenIdsFor(bytes32 _type, address _owner)
        external
        view
        returns (uint256[] memory tokenIds);

    /**
     * @param   _from The address of the token owner.
     * @param   _to The address to receive the transferred token.
     * @param   _tokenId The ID of the specific token.
     * @notice  MUST override transfer function in order to enforce ownership
     *              is transferred with ownership of the owner token.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external override;
}

interface ITokenOwnedContract {

    /**
     * @notice  Modifier MUST be made available for only owner functions.
     */
    modifier onlyOwner() virtual;

    /**
     * @notice  Modifier SHOULD be made available for only the tokenized 
     *              ownership contract to be able to call elevated permission
     *              functions on this owned contract. 
     */
    modifier onlyTokenOwnerContract() virtual;

    /**
     * @return  tokenId The ID of the specific token that owns this contract.
     */
    function ownerToken() external view returns (uint256 tokenId);

    /**
     * @return  tokenOwnerContract The address of the tokenized ownership token
     *          contract that the `ownerToken()` exists on. 
     */
    function getTokenOwnerContract()
        external
        view
        returns (address tokenOwnerContract);

    /**
     * @return  tokenOwned The token type of the tokenized ownership token. 
     */
    function isTokenOwnedContract() external view returns (bytes32 tokenOwned);
}
