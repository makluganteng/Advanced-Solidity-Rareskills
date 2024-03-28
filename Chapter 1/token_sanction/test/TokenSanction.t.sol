// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {TokenSanction} from "../src/TokenSanction.sol";

contract TokenSanctionTest is Test {
    TokenSanction token;
    address alice = address(0x01);
    address bob = address(0x02);

    function setUp() public {
        vm.startPrank(alice);
        token = new TokenSanction("TS", "TokenS", 18);
        vm.stopPrank();
    }

    function test_blacklist_user() public {
        vm.startPrank(alice);
        token.blacklist(bob);
        bool blacklist = token.check_blacklist(bob);
        assertEq(blacklist, true);
        vm.stopPrank();
    }

    function test_transfer_blacklist_user_should_fail() public {
        vm.startPrank(alice);
        token.blacklist(bob);
        vm.expectRevert("User is blacklisted");
        token.transfer(bob, 100e18);
        vm.stopPrank();
    }
}