// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/UnderflowVulnerable.sol";
import "../src/UnderflowFixed.sol";

contract UnderflowTest is Test {
    UnderflowVulnerable vuln;
    UnderflowFixed safe;

    function setUp() public {
        vuln = new UnderflowVulnerable(0);
        safe = new UnderflowFixed(0);
    }

    function testUnderflowVulnerable() public {
        vuln.withdraw(1);

        uint256 result = vuln.balance();

        assertGt(result, 0);
        emit log_uint(result);
    }

    function testUnderflowFixedReverts() public {
        vm.expectRevert();
        safe.withdraw(1);
    }
}