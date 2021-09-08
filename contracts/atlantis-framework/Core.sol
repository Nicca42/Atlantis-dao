// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "./Executor.sol";
import "./CoordinatorLibrary.sol";

contract Core {

    // Contract key to contract instance
    mapping(bytes32 => address) private systemContracts_;

    function viewSystemContract(bytes32 _key) public view returns(address) {
        return systemContracts_[_key];
    }

    function addSystemContract(address _contract) public {
        
    }

    function execute(uint256 _id) public {
        Executor.execute(
            systemContracts_[
                CoordinatorLibrary.EXECUTABLES
            ],
            _id
        );
    }
}