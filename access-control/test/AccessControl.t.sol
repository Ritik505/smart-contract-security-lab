// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {VulnerableAccess} from "../src/VulnerableAccess.sol";
import {SecureAccess} from "../src/SecureAccess.sol";

contract AccessControlTest is Test {
    VulnerableAccess vuln;
    SecureAccess secure;

    address attacker = address(1);

    function setUp() public {
        vuln = new VulnerableAccess();
        secure = new SecureAccess();
    }

    // Exploit vulnerable contract
    function testExploitVulnerable() public {
        vm.prank(attacker);

        vuln.changeOwner(attacker);

        assertEq(vuln.owner(), attacker);
    }

    // Attacker should fail in secure contract
    function testSecureAccessFailsForAttacker() public {
        vm.prank(attacker);

        vm.expectRevert("Not owner");
        secure.changeOwner(attacker);
    }

    //  Owner works correctly
    function testSecureOwnerCanChangeOwner() public {
        address newOwner = address(2);

        secure.changeOwner(newOwner);

        assertEq(secure.owner(), newOwner);
    }
}
