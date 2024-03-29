// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {TokenGodMode} from "../src/TokenGodMode.sol";

contract TokenGodModeTest is Test {
    TokenGodMode token;
    address alice = address(0x01);
    address bob = address(0x02);

    function setUp() public {
        vm.startPrank(alice);
        token = new TokenGodMode("TSG", "TokenGod", 18);
        vm.stopPrank();
    }

    function test_transfer_by_admin() public {
         vm.startPrank(alice);
         token.transferFrom(alice, bob, 100e18);
         assertEq(token.balanceOf(bob), 100e18);
         vm.stopPrank();
    }

    function test_non_admin_should_revert() public {
        test_transfer_by_admin();
        vm.startPrank(bob);
        vm.expectRevert();
        token.transferFrom(bob, alice, 100e18);
        vm.stopPrank();
    }
}