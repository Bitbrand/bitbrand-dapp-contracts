// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/access/AccessControl.sol";
import "openzeppelin-contracts/contracts/proxy/Clones.sol";

import "./interfaces/IBitBrandNFT.sol";

struct ContractMetadata {
    address contractAddress;
    bool isDeployable;
}

error VersionCollision(bytes32 version);
error NotAuthorized();

error VersionNotFound();
error VersionNotDeployable();

contract BitBrandNFTRepository is AccessControl {
    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
    bytes32 public constant PUBLISHER_ROLE = keccak256("PUBLISHER_ROLE");

    // Holds all the information about deployable nft versions
    mapping(bytes32 => ContractMetadata) public contracts;

    event VersionRegistered(bytes32 indexed version, address contractAddress);
    event DeployedNFT(address indexed nftAddress, string name, string symbol);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(DEPLOYER_ROLE, msg.sender);
        _setupRole(PUBLISHER_ROLE, msg.sender);
    }

    /// @notice Register a new version of a contract
    /// @param version semver version of the contract
    /// @param isDeployable whether the contract is deployable or not
    function registerVersion(
        bytes32 version,
        address contractAddress,
        bool isDeployable
    ) public onlyRole(PUBLISHER_ROLE) {
        if (contracts[version].contractAddress != address(0)) {
            revert VersionCollision(version);
        }

        contracts[version] = ContractMetadata(contractAddress, isDeployable);

        emit VersionRegistered(version, contractAddress);
    }

    function deployNFT(
        bytes32 version_,
        string memory name_,
        string memory symbol_,
        address royaltySplitter_,
        uint256 baseRoyalty_,
        string memory _baseURI
    ) public onlyRole(DEPLOYER_ROLE) returns (address) {
        ContractMetadata storage metadata = contracts[version_];
        if (metadata.contractAddress == address(0)) {
            revert VersionNotFound();
        }
        if (!metadata.isDeployable) {
            revert VersionNotDeployable();
        }

        bytes32 salt = keccak256(abi.encodePacked(version_, name_, symbol_));
        IBitBrandNFT nft = IBitBrandNFT(
            Clones.cloneDeterministic(metadata.contractAddress, salt)
        );
        nft.initialize(
            name_,
            symbol_,
            royaltySplitter_,
            baseRoyalty_,
            _baseURI
        );
        emit DeployedNFT(address(nft), name_, symbol_);
        return address(nft);
    }

    function getVersionData(bytes32 version)
        public
        view
        returns (ContractMetadata memory)
    {
        return contracts[version];
    }
}
