// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BitBrandV1Dropper.sol";

contract BitBrandV1DropperTest is Test {
    BitBrandV1Dropper internal dropperContract;
    address internal treasury;

    function setUp() public {
        dropperContract = new BitBrandV1Dropper(treasury);
        treasury = address(1);
        vm.label(treasury, "treasury");
    }

    function testNumberIs42() public {
        /* assertEq(testNumber, 42); */
    }

    function testFailSubtract43() public {
        /* testNumber -= 43; */
    }
}
