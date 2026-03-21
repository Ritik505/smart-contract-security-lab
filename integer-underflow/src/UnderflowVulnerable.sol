// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnderflowVulnerable {
    uint256 public balance;

    constructor(uint256 _balance) {
        balance = _balance;
    }

    function withdraw(uint256 amount) public {
        unchecked {
            balance -= amount;
        }
    }
}