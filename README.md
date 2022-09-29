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
BitBrandNFTRepository: 0x97867816a7f12692698434f809ca652783614c57
BitBrandNFT: 0x5109A5561f728E1e16e62C9f1b1306f5175Fba37
BitBrandMKT: 0x5bC974D85F89a95d45669A21E12D5f4531E8D368
HJNFT: 0x8d4cfa08b2167a9991b0574b6d0b75feeb83614c
ABNFT: 0x83ddbb1bece897e7150d54a2f257793bcccda0aa
EMNFT: 0xf12776bdb77706665a0d6db94fd1f4f768e86173


Commands
forge create src/BitBrandV1Rares.sol:BitBrandV1Rares --rpc-url $INFURA_RPC $ETH_PRIVATE_KEY

forge create src/BitBrandNFTRepository.sol:BitBrandNFTRepository --rpc-url $INFURA_RPC --private-key $ETH_PRIVATE_KEY

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "registerVersion(bytes32,address,bool)" 0x76312e302e300000000000000000000000000000000000000000000000000000 $BASE_NFT_ADDR 1

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e302e300000000000000000000000000000000000000000000000000000 "Hide and Jack - v1" "HJ-1" $DEPLOYER_ADDR 15000 "ipfs://QmXdjkoi4zAJyJUnKLGQTYdj74UNXT3pDgqAU4y6juoRGX/" 12

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e302e300000000000000000000000000000000000000000000000000000 "Armand Basi - v1" "AB-1" $DEPLOYER_ADDR 15000 "ipfs://QmTTsGtEZH88mqHxGmxqZ4Hdo6hkjxGJi3YTfjAbhA2j9k/" 6

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e302e300000000000000000000000000000000000000000000000000000 "Eddy Monetti - v1" "EM-1" $DEPLOYER_ADDR 15000 "ipfs://QmRc2kaV2nwnEoS4uCYh6tDPT8uFcYGjRoyb7VU5wirAyG/" 3

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $NFT_DROP "safeMint(address)" $DEPLOYER_ADDR


NFT Launch Pipeline
- Load the assets on IPFS -> Get basepath metadata
- Generate the metadata json -> Upload to IPFS -> Get basepath metadata
- Deploy the NFT contract (15000, royalties, ipfs metadata root) -> Get NFT address
- Create Listing on Marketplace (NFT addresses, nft ids, price, token)
- Give MINTER_ROLE to the marketplace contract