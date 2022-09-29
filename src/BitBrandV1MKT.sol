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

/// @title BitBrand Marketplace V1
/// @author thev.eth
/// @author bluecco
/// @custom:security-contact security@bitbrand.com
contract BitBrandV1MKT is Pausable, AccessControl {
    struct ListingEntry {
        uint256 nftId;
        uint256 price;
        IBitBrandNFTUpgradeable nftContract;
        IERC20 purchaseToken;
    }

    event TreasuryUpdated(address indexed treasury);

    bytes32 public constant LISTER_ROLE = keccak256("LISTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    mapping(bytes32 => ListingEntry) public listing;
    address public treasury;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address _treasury) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(LISTER_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        treasury = _treasury;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /// @notice Update listing entries
    /// @param nftContracts list of nft contract addresses
    /// @param nftIds list of nft ids
    /// @param prices list of prices
    /// @param purchaseTokens list of purchase token addresses
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

    /// @notice Update Treasury
    /// @param newTreasury new treasury address
    function updateTreasury(address newTreasury)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        treasury = newTreasury;
        emit TreasuryUpdated(newTreasury);
    }

    /// @notice Delete listing entries
    /// @param nftContracts list of nft contract addresses
    /// @param nftIds list of nft ids
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

    /// @notice Buy NFT
    /// @param nftContract nft contract address
    /// @param nftId nft id
    /// @param price price of the nft
    /// @param purchaseToken purchase token address
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

        bool success = purchaseToken.transferFrom(msg.sender, treasury, price);
        if (!success) revert TransferError();

        nftContract.safeMint(msg.sender, nftId);
    }
}
