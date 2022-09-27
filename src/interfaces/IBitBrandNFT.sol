/// // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

import "./IERC2981.sol";

error MaxSupplyReached(uint256 maxSupply);

///
/// @dev Interface for the BitBrand Rares
///
interface IBitBrandNFT is IERC721, IERC2981 {
    function initialize(
        address deployer_,
        string memory name_,
        string memory symbol_,
        address royaltyReceiver_,
        uint256 royaltyPercentage_,
        string memory baseURI_,
        uint256 maxSupply_
    ) external;
}
