// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BitBrandV1MKT.sol";

contract BitBrandV1MKTTest is Test {
    BitBrandV1MKT mktContract;

    function setUp() public {
        mktContract = new BitBrandV1MKT();
    }

    function testNumberIs42() public {
        /* assertEq(testNumber, 42); */
    }

    function testFailSubtract43() public {
        /* testNumber -= 43; */
    }
}
