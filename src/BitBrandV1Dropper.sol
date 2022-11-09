// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/security/Pausable.sol";
import "openzeppelin-contracts/contracts/access/AccessControl.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IBitBrandNFT.sol";

error ParameterLengthMismatch();
error DropAlreadyExists();
error InvalidCreativityDataAtIndex(uint256 i, uint256 j);
error InvalidBuyNFTCall();
error TransferError();

/// @title BitBrand Marketplace V1
/// @author thev.eth
/// @author bluecco
/// @custom:security-contact security@bitbrand.com
contract BitBrandV1Dropper is Pausable, AccessControl {
    event TreasuryUpdated(address indexed treasury);

    bytes32 public constant LISTER_ROLE = keccak256("LISTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    // Total 2 slots
    struct CreativityData {
        uint256 mintPrice;
        IERC20 mintToken;
        uint24 totalSupply;
        uint24 mintedSupply;
        uint48 offsetId;
    }

    mapping(IBitBrandNFT => mapping(uint256 => CreativityData)) public drops;
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

    /// @notice add new drops
    /// @notice drops that are added are final and cannot be changed
    /// @param _drops list of nft contract addresses
    /// @param _creativityData data of each creativity of the drop
    function addDrops(
        IBitBrandNFT[] calldata _drops,
        CreativityData[][] calldata _creativityData
    ) external whenNotPaused onlyRole(LISTER_ROLE) {
        if (_drops.length != _creativityData.length) {
            revert ParameterLengthMismatch();
        }

        for (uint256 i = 0; i < _drops.length; i++) {
            CreativityData memory creativity = drops[_drops[i]][0];
            if (creativity.mintPrice != 0) {
                revert DropAlreadyExists();
            }

            uint256 nextOffsetId = 0;
            for (uint256 j = 0; j < _creativityData[i].length; j++) {
                if (
                    !validateCreativityData(_creativityData[i][j], nextOffsetId)
                ) {
                    revert InvalidCreativityDataAtIndex(i, j);
                }
                nextOffsetId += _creativityData[i][j].totalSupply;
                drops[_drops[i]][j] = _creativityData[i][j];
            }
        }
    }

    function validateCreativityData(
        CreativityData calldata data,
        uint256 nextOffsetId
    ) internal pure returns (bool) {
        return
            (data.mintPrice > 0 && data.mintToken != IERC20(address(0))) ||
            data.totalSupply > 0 ||
            data.mintedSupply == 0 ||
            data.offsetId == nextOffsetId;
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

    /// @notice mint next available NFT from a drop and a creativity
    /// @param drop contract address of the nft collection
    /// @param creativityId id of the creativity
    function mintNextAvailable(IBitBrandNFT drop, uint256 creativityId)
        external
        whenNotPaused
    {
        CreativityData storage creativity = drops[drop][creativityId];
        if (
            creativity.mintPrice == 0 || // covers the case where the drop does not exist
            creativity.mintedSupply >= creativity.totalSupply
        ) {
            revert InvalidBuyNFTCall();
        }

        bool success = creativity.mintToken.transferFrom(
            msg.sender,
            treasury,
            creativity.mintPrice
        );
        if (!success) revert TransferError();

        uint256 tokenId = creativity.offsetId + creativity.mintedSupply;
        creativity.mintedSupply += 1;

        drop.safeMint(msg.sender, tokenId);
    }
}
