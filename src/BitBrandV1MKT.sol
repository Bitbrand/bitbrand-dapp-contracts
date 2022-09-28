// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/security/Pausable.sol";
import "openzeppelin-contracts/contracts/access/AccessControl.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IERC2981Upgradeable.sol";
import "./interfaces/IBitBrandNFTUpgradeable.sol";

error ParameterLengthMismatch();
error InvalidBuyNFTCall();
error TransferError();
error NotEnoughBalance();

/// @title BitBrand Marketplace V1
/// @author thev.eth
/// @author bluecco
/// @custom:security-contact security@bitbrand.com
contract BitBrandV1MKT is Pausable, AccessControl {
    bytes32 public constant LISTER_ROLE = keccak256("LISTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // struct per il listing
    // - NFT contract => IBitBrandNFT
    // - NFT id
    // - price => uint256
    // - purchase token ERC20
    // mapping del listing => chiave keccak256 (NFTContract, NFT token id)
    // Holds all the information about deployable nft versions
    struct ListingEntry {
        uint256 nftId;
        uint256 price;
        IBitBrandNFTUpgradeable nftContract;
        IERC20 purchaseToken;
    }
    mapping(bytes32 => ListingEntry) public listing;

    // call per creare listing massivo
    function updateListing(
        IBitBrandNFTUpgradeable[] calldata nftContracts,
        uint256[] calldata nftIds,
        uint256[] calldata prices,
        IERC20[] calldata purchaseTokens
    ) external whenNotPaused onlyRole(LISTER_ROLE) {
        if (
            nftContracts.length != nftIds.length ||
            nftIds.length != prices.length ||
            prices.length != purchaseTokens.length
        ) {
            revert ParameterLengthMismatch();
        }

        for (uint256 i = 0; i < nftContracts.length; i++) {
            bytes32 listingKey = keccak256(
                abi.encodePacked(nftContracts[i], nftIds[i])
            );
            listing[listingKey] = ListingEntry(
                nftIds[i],
                prices[i],
                nftContracts[i],
                purchaseTokens[i]
            );
        }
    }

    function deleteListing(
        IBitBrandNFTUpgradeable[] calldata nftContracts,
        uint256[] calldata nftIds
    ) external whenNotPaused onlyRole(LISTER_ROLE) {
        if (nftContracts.length != nftIds.length)
            revert ParameterLengthMismatch();

        for (uint256 i = 0; i < nftContracts.length; i++) {
            bytes32 listingKey = keccak256(
                abi.encodePacked(nftContracts[i], nftIds[i])
            );
            delete listing[listingKey];
        }
    }

    function buyNFT(
        IBitBrandNFTUpgradeable nftContract,
        uint256 nftId,
        uint256 price,
        IERC20 purchaseToken
    ) external whenNotPaused {
        bytes32 listingKey = keccak256(abi.encodePacked(nftContract, nftId));
        ListingEntry memory listingEntry = listing[listingKey];

        if (
            listingEntry.nftContract != nftContract ||
            listingEntry.nftId != nftId ||
            listingEntry.price != price ||
            listingEntry.purchaseToken != purchaseToken
        ) {
            revert InvalidBuyNFTCall();
        }

        address nftOnwer = nftContract.ownerOf(nftId);
        uint256 amount = price;

        (address royaltyReceiver, ) = nftContract.royaltyInfo(nftId, price);

        uint256 royaltyAmount = (amount * 20) / 100; // take 20% as marketplace fee for first sale
        amount -= royaltyAmount;

        bool royaltySuccess = purchaseToken.transferFrom(
            msg.sender,
            royaltyReceiver,
            royaltyAmount
        );
        if (!royaltySuccess) revert TransferError();

        bool success = purchaseToken.transferFrom(msg.sender, nftOnwer, amount);
        if (!success) revert TransferError();

        nftContract.safeTransferFrom(nftOnwer, msg.sender, nftId);
    }
}
