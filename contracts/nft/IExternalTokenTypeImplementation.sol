// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

/**
 * @title   An expansion for `IExternallyImplementedTypedToken` allowing for
 *          external contracts to control minting rights for specific token
 *          types.
 * @author  Veronica Coutts <hello@vee.dev> @vonnie610 (twitter)
 * @notice  A standard token types with external implementations. These external
 *          implementations may wrap transfer functionality in order to extend
 *          functionality further.
 */
interface IExternalTokenTypeImplementation {
    /**
     * @return  tokenTypeImplemented The token type that this external
     *          implementation is extending.
     */
    function getTokenType()
        external
        view
        returns (bytes32 tokenTypeImplemented);

    /**
     * @return  tokenImplementation The address for the token implementation
     *          that this external implementation is wrapping.
     */
    function getUnderlyingToken()
        external
        view
        returns (address tokenImplementation);

    /**
     * @return  implementationType The type of external implementation this
     *          extension is.
     */
    function getImplementationType()
        external
        view
        returns (bytes32 implementationType);

    /**
     * @param   _from The address of the token owner.
     * @param   _to The address to receive the transferred token.
     * @param   _tokenId The ID of the specific token.
     * @notice  OPTIONAL External token types may override the transfer function
     *              in order to extend functionality further. SHOULD an 
     *              extension implement `transferFrom` calling `transferFrom`
     *              MUST then revert on the base implementation. 
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;
}
