// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/security/PausableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/CountersUpgradeable.sol";

import "./interfaces/IERC2981.sol";

/// @custom:security-contact security@bitbrand.com
contract BitBrandV1Rares is
    Initializable,
    ERC721Upgradeable,
    PausableUpgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable,
    IERC2981
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    CountersUpgradeable.Counter private _tokenIdCounter;
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    uint256 private constant ONE_PERCENT = 100;
    uint256 private constant MAX_ROYALTY = 100 * ONE_PERCENT;

    address royaltyReceiver;
    uint256 royaltyPercentage;

    string private _dynamicBaseURI;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name_,
        string memory symbol_,
        address royaltyReceiver_,
        uint256 royaltyPercentage_,
        string memory baseURI_
    ) public initializer {
        __ERC721_init(name_, symbol_);
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);

        royaltyReceiver = royaltyReceiver_;
        royaltyPercentage = royaltyPercentage_;
        _dynamicBaseURI = baseURI_;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    function _baseURI() internal view override returns (string memory) {
        return _dynamicBaseURI;
    }

    function royaltyInfo(
        uint256, /*_tokenId*/
        uint256 _salePrice
    ) external view returns (address receiver, uint256 royaltyAmount) {
        uint256 royalty = (_salePrice * royaltyPercentage) / ONE_PERCENT;
        return (royaltyReceiver, royalty);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(IERC165, ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return
            type(IERC2981).interfaceId == interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
