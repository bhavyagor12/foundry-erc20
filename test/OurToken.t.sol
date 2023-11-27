// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken ourToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_BALANCE = 100 ether;
    uint256 public constant TRANSFER_VALUE = 0.1 ether;
    uint256 public constant APPROVE_AMOUNT = 1 ether;

    function setUp() external {
        DeployOurToken deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, INITIAL_BALANCE);
    }

    function testBobBalance() public {
        vm.prank(bob);
        uint256 balanceBob = ourToken.balanceOf(bob);
        assert(balanceBob == INITIAL_BALANCE);
    }

    function testAllowancesWorks() public {
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, TRANSFER_VALUE);
    }

    modifier allowTransferFromBob() {
        vm.prank(bob);
        vm.deal(bob, 10 ether);
        ourToken.approve(alice, APPROVE_AMOUNT);
        _;
    }

    function testTranferWorksAfterApproval() public allowTransferFromBob {
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, TRANSFER_VALUE);
    }

    function testTransferFailsWhenAmountGreaterThanApprovedAmount()
        public
        allowTransferFromBob
    {
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 8 ether);
    }
}
