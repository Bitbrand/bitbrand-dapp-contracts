// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BitBrandV1MKT.sol";

contract BitBrandV1MKTTest is Test {
    BitBrandV1MKT internal mktContract;
    address internal treasury;

    function setUp() public {
        mktContract = new BitBrandV1MKT(treasury);
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
