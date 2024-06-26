![alt text](imgs/image.png "Hikuru")

[![Follow me on Twitter](https://img.shields.io/badge/Twitter-%231DA1F2.svg?style=for-the-badge&logo=Twitter&logoColor=white)](https://twitter.com/HikuruOfficial)
[![Discord: @hikuru](https://img.shields.io/badge/Discord-%235865F2.svg?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mevde2mRSw)
[![Telegram](https://img.shields.io/badge/Telegram-%235865F2.svg?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/HikuruOfficial)




# Hikuru Aleo Domain Smart Contract

### Deployed contract
[hikuru_ans_v1.aleo](https://explorer.hamp.app/program?id=hikuru_ans_v1.aleo)


## Introduction
This is the official documentation for the Hikuru Aleo Domain smart contract, authored by Hikuru. This contract is built on Aleo, a blockchain platform, and it manages the ownership and registration of unique names (NFTs) associated with user accounts. In this document, we will provide an overview of the contract's functionality, with a specific focus on the registration process and how data is stored. Build on Aleo NFT standard `ARC721`

## Table of Contents
1. [Contract Overview](#contract-overview)
2. [Contract Structure](#contract-structure)
   - [Toggle Settings](#toggle-settings)
   - [General Settings](#general-settings)
   - [Data Structures](#data-structures)
3. [Contract Functions](#contract-functions)
   - [Initialize Collection](#initialize-collection)
   - [Update Base URI](#update-base-uri)
   - [Update Toggle Settings](#update-toggle-settings)
   - [Register](#register)
   - [Set Primary Name](#set-primary-name)
   - [Burn](#burn)
   - [Transfer Public](#transfer-public)
4. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
   - [Usage](#usage)
5. [Support](#support)
6. [License](#license)

---

## Contract Overview

The Hikuru Aleo Domain smart contract is designed to manage the registration and ownership of unique names (NFTs) on the Aleo blockchain. Users can register names and transfer ownership of these names to others. The contract also includes various settings to control minting, freezing, and other contract behavior.

---

## Contract Structure

### Toggle Settings
- `toggle_settings` is a mapping that stores toggle settings for the contract.
- Bit 0: Collection initialization status.
- Bit 1: Allow minting by minters.
- Bit 2: Require minters to have a mint record.
- Bit 3: Contract freeze status.

### General Settings
- `general_settings` is a mapping that stores general settings for the contract.
- Key 0: Number of mintable NFTs (all editions).
- Key 1: Number of total NFTs (first-editions) that can be minted.
- Key 2: Symbol for the NFT.
- Key 3-6: Base URI for NFTs.

### Data Structures
- `TokenId`: A unique identifier for the NFT.
- `BaseURI`: Part of the base URI for the NFT.
- `Name`: Represents the name in ASCII text.
- `SymbolBits`: Represents the symbol in ASCII text.
- `NFT`: Represents an NFT.
- `AleoNameService`: Represents the right to mint a name.
- Various mappings for managing ownership and name information.

---

## Contract Functions

### Initialize Collection
- `initialize_collection`: Initializes the collection (can only be called once by the contract owner).
  - `total`: total number of nfts that can be created
  - `symbol`: short collection symbol
  - `base_uri`: url to base collection info directory

### Update Base URI
- `update_base_uri`: Updates the base URI for NFTs.
  - `base_uri`: url to base collection info directory

### Update Toggle Settings
- `update_toggle_settings`: Toggles minting, whitelist requirement, or freezes the contract.
  - `toggle_settings_bitstring`: way to manage the collection

### Register
- `register`: Registers a new user with the NFT collection. Main function for minting NFTs - can only be called by minters.
  - `name`: name the user wants to register
  - `start_time`: real time timestamp
  - `months`: number of months for which the user wants to reserve a name.

### Set Primary Name
- `set_primary_name`: Sets the primary name for a user.
  - `name`: main name which user want to use in search

### Burn
- `burn`: Burns (destroys) an NFT.
  - `name`: name which user want to destroy for him/herself

### Transfer Public
- `transfer_public`: Transfers an NFT to another user.
   - `nft`: nft object which user want to transfer
   - `receiver`: address of new owner of nft
---

## Getting Started

### Prerequisites
Before using this smart contract, you need the following:
- An Aleo blockchain wallet and funds for transactions.
- Basic knowledge of Aleo smart contracts and their deployment.

### Installation
This smart contract is deployed on the Aleo blockchain and can be accessed through compatible Aleo wallet interfaces.

### Usage
1. Initialize the collection: This can be done only once by the contract owner to set up the NFT collection.

2. Update Base URI: This function allows you to update the base URI for NFTs, providing metadata for the collection.

3. Update Toggle Settings: Use this function to toggle various contract settings, such as minting and freezing.

4. Register: Register a new user with the NFT collection, specifying a name, start time, months, and multiplier.

5. Set Primary Name: Set the primary name for a user.

6. Burn: Burn (destroy) an NFT.

7. Transfer Public: Transfer an NFT to another user.


---

## Support
For any questions or support related to this contract, please contact Hikuru at [https://hikuru.com](https://hikuru.com).

---


## License
This smart contract and documentation are provided under the [license terms](#) specified by Hikuru.

**Offical Hikuru Aleo Domain - [https://hikuru.com](https://hikuru.com)**

---
