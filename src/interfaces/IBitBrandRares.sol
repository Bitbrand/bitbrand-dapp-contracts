/// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

///
/// @dev Interface for the BitBrand Rares
///
interface IBitBrandRares {
    function initialize(
        string memory name_,
        string memory symbol_,
        address royaltyReceiver_,
        uint256 royaltyPercentage_,
        string memory baseURI_
    ) external;
}
