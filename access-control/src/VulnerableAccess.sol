// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableAccess {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //  Vulnerable: anyone can change owner
    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    function sensitiveAction() public view returns (string memory) {
        require(msg.sender == owner, "Not owner");
        return "Sensitive data";
    }
}
