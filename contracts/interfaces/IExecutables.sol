pragma solidity 0.8.5;

interface IExecutables {
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
        external 
        view 
        returns(
            address[] memory,
            uint256[] memory,
            bytes[] memory
        );
}