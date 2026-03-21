// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 

contract UnderflowFixed {
    uint256 public balance;

    constructor(uint256 _balance) {
        balance = _balance;
    }

    function withdraw(uint256 amount) public {
        require(balance >= amount, "Insufficient balance");
        balance -= amount;
    }
}