// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

/**
 * @title   A new standard for typed NFTs within the same contract.
 * @author  Veronica Coutts <hello@vee.dev> @vonnie610 (twitter)
 * @notice  A standard for multiple token types within a single NFT. These types
 *          can have external implementations, allowing for extendable
 *          functionality of individual types. For more information see:
 *          `ExternalTokenTypeImplementation`.
 */
interface ITypedToken {
    // MUST be emitted on mint, transfer, and burn.
    event Transfer(
        address indexed from, // if 0x0 call is mint
        address indexed to, // if 0x0 call is burn
        uint256 tokenId, // ID of the token
        bytes32 indexed tokenType // Type of token
    );

    //--------------------------------------------------------------------------
    // VIEW
    //--------------------------------------------------------------------------

    /**
     * @notice  Checks the balancer of the `_owner` across all token types.
     * @param   _owner Address being checked.
     * @return  balance The balance of all owned tokens.
     */
    function balanceOfAll(address _owner)
        external
        view
        returns (uint256 balance);

    /**
     * @param   _type Type of token.
     * @param   _owner Address being checked.
     * @return  balance Balance of the `_owner` in the `_type` of token.
     */
    function balanceOfType(bytes32 _type, address _owner)
        external
        view
        returns (uint256 balance);

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
     * @param   _tokenId The ID of the specific token.
     * @return  owner The address of the owner of the token.
     */
    function ownerOf(uint256 _tokenId) external view returns (address owner);

    /**
     * @param   _tokenId The ID of the specific token.
     * @return  tokenType The tokens type.
     */
    function typeOf(uint256 _tokenId) external view returns (bytes32 tokenType);

    /**
     * @param   _tokenType The token type.
     * @return  name Name of the token type.
     * @return  symbol Symbol of the token type.
     * @return  externalImplementation The address for an external
     *          implementation. If address is 0x0 address and name and symbol
     *          are not blank, the token is implemented internally in this
     *          parent token.
     */
    function getTypeInformation(bytes32 _tokenType)
        external
        view
        returns (
            string memory name,
            string memory symbol,
            address externalImplementation
        );

    /**
     * @param   _owner The address of the owner of the token.
     * @param   _spender The address of the spender for the token.
     * @param   _tokenId The ID of the specific token.
     * @return  bool If the spender is approved as a spender for the specified
     *          token of the owner.
     */
    function isApprovedForToken(
        address _owner,
        address _spender,
        uint256 _tokenId
    ) external view returns (bool);

    /**
     * @param   _owner The address of the owner of the token.
     * @param   _operator The address of the operator for the specified token
     *          type.
     * @param   _type The type of the token.
     * @return  bool If the operator is approved as a spender for the specific
     *          token type for the owner.
     */
    function isApprovedForType(
        address _owner,
        address _operator,
        bytes32 _type
    ) external view returns (bool);

    //--------------------------------------------------------------------------
    // (public & external) STATE MODIFYING
    //--------------------------------------------------------------------------

    /**
     * @param   _spender The address of the spender for the token.
     * @param   _tokenId The ID of the specific token.
     * @param   _approved If the spender has has spending rights over the
     *          specified token.
     * @notice  SHOULD revert if `msg.sender` is not owner of the `_tokenId`.
     */
    function approveForToken(
        address _spender,
        uint256 _tokenId,
        bool _approved
    ) external;

    /**
     * @param   _operator The address of the operator for the token type.
     * @param   _type The type of token.
     * @param   _approved If the operator has has spending rights over the
     *          specified types of token.
     * @notice  SHOULD NOT revert if `msg.sender` does not have balance of the
     *              specified token type.
     */
    function approveForType(
        address _operator,
        bytes32 _type,
        bool _approved
    ) external;

    /**
     * @param   _from The address of the token owner.
     * @param   _to The address to receive the transferred token.
     * @param   _tokenId The ID of the specific token.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;
}
