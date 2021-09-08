// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "../interfaces/IExecutables.sol";

/**
 * @author  @vonnie610 (Twitter) @Nicca42 (GitHub)
 * @title   Executor of executable tokens
 * @notice  This contract allows you to execute an executable token. It does not
 *          verify the correctness of the token nor of the executor token 
 *          instance.
 */
library Executor {

    /**
     * @param   _executablesInstance Address of the executable token instance.
     * @param   _id The ID of the token to execute.
     * @notice  This library function does no verification of the executable 
     *          token or executable instance. 
     */
    function execute(
        address _executablesInstance, 
        uint256 _id
    ) external {
        address[] memory targets;
        uint256[] memory values;
        bytes[] memory callData;

        (
            targets, 
            values, 
            callData
        ) = IExecutables(_executablesInstance).viewExecutable(_id);

        for (uint256 i = 0; i < targets.length; i++) {
            (bool success, ) = targets[i].call{
                    value: values[i]
                }(
                    callData[i]
                );
            require(success, "Executor: Execution failed");   
        }
    }
}