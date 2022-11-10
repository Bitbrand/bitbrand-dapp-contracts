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
BitBrandNFT: 0xb7344a378BB2276B04f72Bf4A8e3c30389F8C9C6
BitBrandDropper: 0xD4E46D2Cece7152d20482b4783038C9eC7b6Deb4
HJNFT: 0x8d4cfa08b2167a9991b0574b6d0b75feeb83614c
ABNFT: 0x8D7d9F285202FFC9e03825D17aBeA9bfE5770702
EMNFT: 0xf12776bdb77706665a0d6db94fd1f4f768e86173

forge verify-contract 0x139F7D3f2cf9fAD52C3b6b09CBdd7bB4181577f2 BitBrandV1Dropper 9A4BEPDJPE15W25TJ1RAKDMIWJ59H1SAI9 --chain goerli

Commands
forge create src/BitBrandV1RaresUpgradeable.sol:BitBrandV1RaresUpgradeable --rpc-url $INFURA_RPC --private-key $ETH_PRIVATE_KEY

forge create src/BitBrandNFTRepository.sol:BitBrandNFTRepository --rpc-url $INFURA_RPC --private-key $ETH_PRIVATE_KEY

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "registerVersion(bytes32,address,bool)" 0x76312e312e300000000000000000000000000000000000000000000000000000 $BASE_NFT_ADDR 1

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e302e300000000000000000000000000000000000000000000000000000 "Hide and Jack - v1" "HJ-1" $DEPLOYER_ADDR 15000 "ipfs://QmXdjkoi4zAJyJUnKLGQTYdj74UNXT3pDgqAU4y6juoRGX/" 12

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e312e300000000000000000000000000000000000000000000000000000 "Nacho RIP + Armand Basi NFT" "NACHO-RIP" $DEPLOYER_ADDR 15000 "ipfs://QmTTsGtEZH88mqHxGmxqZ4Hdo6hkjxGJi3YTfjAbhA2j9k/" 600

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76312e302e300000000000000000000000000000000000000000000000000000 "Eddy Monetti - v1" "EM-1" $DEPLOYER_ADDR 15000 "ipfs://QmRc2kaV2nwnEoS4uCYh6tDPT8uFcYGjRoyb7VU5wirAyG/" 3

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $NFT_DROP "safeMint(address)" $DEPLOYER_ADDR


ON ETHERSCAN

["0x8D7d9F285202FFC9e03825D17aBeA9bfE5770702"]
[[["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,0],["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,100],["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,200],["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,300],["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,400],["80000000000000000000","0x97cb342cf2f6ecf48c1285fb8668f5a4237bf862",100,0,500]]]


NFT Launch Pipeline
- Load the assets on IPFS -> Get basepath metadata
- Generate the metadata json -> Upload to IPFS -> Get basepath metadata
- Deploy the NFT contract (15000, royalties, ipfs metadata root) -> Get NFT address
- Create Listing on Marketplace (NFT addresses, nft ids, price, token)
- Give MINTER_ROLE to the marketplace contract