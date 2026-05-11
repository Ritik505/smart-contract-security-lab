// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/ReentrancyFixed.sol";
import "../src/Attacker.sol";

contract ReentrancyFixedTest is Test {
    ReentrancyFixed bank;
    Attacker attacker;

    function setUp() public {
        bank = new ReentrancyFixed();

        attacker = new Attacker(address(bank));

        vm.deal(address(this), 10 ether);
        vm.deal(address(attacker), 1 ether);

        // Victim deposits 5 ETH
        bank.deposit{value: 5 ether}();
    }

    function testReentrancyAttackFails() public {
        vm.expectRevert();

        // Attack should fail
        attacker.attack{value: 1 ether}();

        // Bank funds should remain safe
        assertEq(address(bank).balance, 5 ether);
    }
}
