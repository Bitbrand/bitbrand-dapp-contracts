# BitBrand Contracts
This repository contains the smart contracts for the BitBrand platform.

The contracts are written in Solidity, using foundry as a development framework.

## Project Scope

BitBrand aims to provide a streamlining service for the creation of branded NFTs, with different levels of customization.
Such customization affects many aspects of the NFTs.

The variables for each NFT are:
- mintable quantity (eg 10_000)
- floor price (eg 0.1 ETH)
- treasury address (eg 0x1234...)
- royalties amount (eg 10%)
- marketplace whitelisting

## Contracts

- First drop
- Secondary market su ogni marketplace
- Rarities (limitato, auction floor price)
- Mass-Market (molto broad, digital assets)

Goerli

Test mint: 0x1f87894507Df49e60Cb2567fa5D6CBE34ea6aA01
[Broken] BitBrandV1Rares.sol: 0x1f87894507Df49e60Cb2567fa5D6CBE34ea6aA01
BitBrandV1Rares.sol: 0x6F014797d5D8731Ae8Cce4d22f7A5bB27349751f
BitBrandNFTRepository.sol: 0xa18cc749215988f395577402bc9813c546464842

[Broken] H&J Drop 1: 0x1972729F9FFd9830294cBD9b1784F27fCd656d63
[OK] H&J Drop 2: 0x5A1243586D49c9cf579DF814bA5E08d320254eC5


forge create src/BitBrandV1Rares.sol:BitBrandV1Rares --rpc-url $INFURA_RPC $ETH_PRIVATE_KEY

forge create src/BitBrandNFTRepository.sol:BitBrandNFTRepository --rpc-url $INFURA_RPC --private-key $ETH_PRIVATE_KEY

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "registerVersion(bytes32,address,bool)" 0x76302e302e330000000000000000000000000000000000000000000000000000 0x6F014797d5D8731Ae8Cce4d22f7A5bB27349751f 1

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string)" 0x76302e302e330000000000000000000000000000000000000000000000000000 "H&J Drop 2" "H&J-2" $DEPLOYER_ADDR 15000 "ipfs://QmXdjkoi4zAJyJUnKLGQTYdj74UNXT3pDgqAU4y6juoRGX/"

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $NFT_DROP "safeMint(address)" $DEPLOYER_ADDR
