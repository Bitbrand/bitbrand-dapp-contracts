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
BitBrandNFT: 0x034aFc445381Efc4CAfb6FD58b332df02f0efc15
BitBrandMKT: 0x91354b151fEF095f234E820382a5C1c4aBE6BAf4
HJNFT: 0x894F9704dC7835Cfb0484edAe18B43Ea9C462CED
ABNFT: 0x1d112651fC039C2F498B31bc718857576d7d0297
EMNFT: 0x47cCBCEE44CBDba704E021668B894b36cb0cD24F


Commands
forge create src/BitBrandV1Rares.sol:BitBrandV1Rares --rpc-url $INFURA_RPC $ETH_PRIVATE_KEY

forge create src/BitBrandNFTRepository.sol:BitBrandNFTRepository --rpc-url $INFURA_RPC --private-key $ETH_PRIVATE_KEY

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "registerVersion(bytes32,address,bool)" 0x76302e302e310000000000000000000000000000000000000000000000000000 $BASE_NFT_ADDR 1

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $REPO_ADDR "deployNFT(bytes32,string,string,address,uint256,string,uint256)" 0x76302e302e310000000000000000000000000000000000000000000000000000 "Eddy Monetti - v1" "EM-1" $DEPLOYER_ADDR 15000 "ipfs://QmRc2kaV2nwnEoS4uCYh6tDPT8uFcYGjRoyb7VU5wirAyG/" 3

cast send --private-key $ETH_PRIVATE_KEY --rpc-url $INFURA_RPC $NFT_DROP "safeMint(address)" $DEPLOYER_ADDR