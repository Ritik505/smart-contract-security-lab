// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureAccess {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "Not owner");
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero address");
        owner = newOwner;
    }

    function sensitiveAction() public view onlyOwner returns (string memory) {
        return "Sensitive data";
    }
}
