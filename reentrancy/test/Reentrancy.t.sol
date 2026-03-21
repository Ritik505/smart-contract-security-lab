// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";
import "../src/Attacker.sol";

contract ReentrancyTest is Test {
    VulnerableBank bank;
    Attacker attacker;

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new Attacker(address(bank));

        vm.deal(address(this), 10 ether);
        vm.deal(address(attacker), 1 ether);

        bank.deposit{value: 5 ether}();
    }

    function testReentrancyAttack() public {
        attacker.attack{value: 1 ether}();

        assertEq(address(bank).balance, 0);
        assertGt(address(attacker).balance, 5 ether);
    }
}
