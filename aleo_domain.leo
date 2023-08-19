// Created by Hikuru

// import credits.leo;

program ans_v1.aleo{
   
    // keys: just two, 0u8 which corresponds to different on/off settings for the contract, and 1u8
    // which corresponds to the mint block height.
    // values: the bitstring that represents the settings that can be toggled
    // in order of least significant bit index to most significant bit:
    // 0: collection has been initialized
    // 1: can minters mint
    // 2: do minters have to have a mint record (i.e. is the private whitelist a requirement)
    // 3: is the collection frozen
    mapping toggle_settings: u8 => u32;
    // values: setting value
    mapping general_settings: u8 => u128;

    
    // The token id is a 256 bit number that is the unique identifier for the NFT.
    struct TokenId {
        data1: u128, 
        data2: u128,
    }
  
    // base uri ascii bits. Include as many data pieces as necessary to encapsulate the uri. Padded with 0s at the end.
    struct BaseURI {
        data0: u128, // Part 1 of the base uri in bits. Bits should be the representation of the hexadecimal bytes for the ASCII text of the URL
        data1: u128,
        data2: u128,
        data3: u128
    }
  
    // The name is ascii text represented in bits, and the u128 value of the bitstring.
    struct Name {
        data0: u128, 
        data1: u128,
        data2: u128,
        data3: u128
    }
    
    // The sybmol's ascii text represented in bits, and the u128 value of the bitstring.
    struct SymbolBits {
        data: u128 
    }
  
    // The passport is the NFT that represents the identity of the user.
    record NFT {
        private owner: address,
        private data: TokenId,
        private edition: scalar, // which edition of the nft this particular one is -- will be 0 for unique NFTs
        private name: Name,
        private end_time: u64,
    }

    // The mint record is the NFT that represents the right to mint a name.
    struct AleoNameService {
        ans_owner: address,
        name: Name,
        end_time: u64,
        data: TokenId
    }


    
    mapping nft_owners: field =>  address;
    mapping name_to_owner: Name => address;
    mapping primary_name: address => Name;
    mapping name_info: Name => AleoNameService;




    // Initialize the collection - can only be called once by the owner of the contract
    transition initialize_collection(
        public total: u128,
        public symbol: u128,
        public base_uri: BaseURI,
    ) {
        assert_eq(self.caller, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl);
        return then finalize(total, symbol, base_uri);
    }
  
    finalize initialize_collection(
        public total: u128,
        public symbol: u128,
        public base_uri: BaseURI,
    ) {
        // Ensure initialize cannot be called twice!
        let is_initialized: u32 = toggle_settings.get_or_use(0u8, 0u32);
        assert_eq(is_initialized, 0u32);
  
        general_settings.set(0u8, 0u128); // number of mintable NFTs (all editions)
        general_settings.set(1u8, total); // Number of total NFTs (first-editions) that can be minted
        general_settings.set(2u8, symbol); // Symbol for the NFT
        general_settings.set(3u8, base_uri.data0); // Base URI for NFT
        general_settings.set(4u8, base_uri.data1);
        general_settings.set(5u8, base_uri.data2);
        general_settings.set(6u8, base_uri.data3);
        toggle_settings.set(0u8, 5u32);
        toggle_settings.set(1u8, 0u32); // block height when mint is allowed
    }

    // Update the base uri for the NFTs
    transition update_base_uri(public base_uri: BaseURI) {
        assert_eq(self.caller, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl);
        return then finalize(base_uri);
    }

    finalize update_base_uri(public base_uri: BaseURI) {
       // Ensure collection is initialized and not frozen.
        let is_initialized_and_not_frozen: u32 = toggle_settings.get_or_use(0u8, 1u32);
        assert_eq(is_initialized_and_not_frozen, 1u32);

        general_settings.set(3u8, base_uri.data0); // Base URI for NFT
        general_settings.set(4u8, base_uri.data1);
        general_settings.set(5u8, base_uri.data2);
        general_settings.set(6u8, base_uri.data3);
    }



    // call this function to toggle minting, the whitelist requirement, or to permanently freeze the contract
    transition update_toggle_settings(public toggle_settings_bitstring: u32) {
        assert_eq(self.caller, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl);
        return then finalize(toggle_settings_bitstring);
    }

    finalize update_toggle_settings(public toggle_settings_bitstring: u32) {
        // Ensure collection is initialized and not frozen.
        let toggle_settings_status: u32 = toggle_settings.get(0u8);
        // initialized & frozen flags = 0b0000...1001 = 9u32
        // what the settings should be = 0b0000...0001 = 1u32
        let is_initialized_and_not_frozen: u32 = toggle_settings_status & 9u32;
        assert_eq(is_initialized_and_not_frozen, 1u32);

        // Ensure updated settings are not uninitializing the collection.
        let still_initialized: u32 = toggle_settings_bitstring & 1u32;
        assert_eq(still_initialized, 1u32);

        toggle_settings.set(0u8, toggle_settings_bitstring);
    }

  



    // Register a new user with the NFT collection
    transition register(
        public name: Name,
        public start_time: u64,
        public months: u64,
        public multiplier: u64
    ) -> NFT {

        // months must be greater than 0
        assert_eq(months, 0u64);

        // credits.leo/transfer_private(credits.aleo/credits, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl, months*400000u64*multiplier);

        let ansHash: field = BHP256::hash_to_field(name);
        let end_time: u64 = start_time + (months * 30u64 * 24u64 * 60u64 * 60u64);


        return NFT {
            owner: self.caller,
            data: TokenId {data1: 0u128, data2: 0u128},
            edition: 0scalar,
            name: name,
            end_time: end_time
        } then finalize(self.caller, name, end_time, ansHash, months, multiplier);
    }

    finalize register(owner: address, name: Name, end_time: u64, ansHash: field, months: u64, multiplier: u64) {
        // Ensure collection is initialized and not frozen.
        let is_initialized_and_not_frozen: u32 = toggle_settings.get_or_use(0u8, 1u32);
        assert_eq(is_initialized_and_not_frozen, 1u32);

        let contains_nameHash: bool = Mapping::contains(nft_owners, ansHash);
        assert_eq(contains_nameHash, true); // name is already registered to somebody else

        let contains_name: bool = Mapping::contains(name_to_owner, name);
        assert_eq(contains_name, true); // name is already registered to somebody else

        // Set name and owner mapping
        nft_owners.set(ansHash, owner); 
        name_to_owner.set(name, owner);
        name_info.set(name, AleoNameService {ans_owner: owner, name: name, end_time: end_time, data: TokenId {data1: 0u128, data2: 0u128}});

        // check is owner set already primary_name if not set it
        let contains_owner: bool = Mapping::contains(primary_name, owner);
        if (contains_owner == false) {
            primary_name.set(owner, name);
        }
    }


    // Set primary name for the user
    transition set_primary_name (
        name: Name
    ) {
        return then finalize(self.caller, name);
    }
    finalize set_primary_name (owner: address, name: Name) {
        // check is onwer has name registered
        let ans_owner: address = Mapping::get(name_to_owner, name);
        assert_neq(ans_owner, owner); // name is already registered to somebody else

        primary_name.set(owner, name);
    }




    // Burn the NFT
    transition burn(
        public name: Name,
    ) {
        let ansHash: field = BHP256::hash_to_field(name);
        return then finalize(self.caller, name, ansHash);
    }

    finalize burn(owner: address, name: Name, ansHash: field) {
        // Ensure collection is initialized and not frozen.
        let is_initialized_and_not_frozen: u32 = toggle_settings.get_or_use(0u8, 1u32);
        assert_eq(is_initialized_and_not_frozen, 1u32);

        let contains_owner: address = Mapping::get(nft_owners, ansHash);
        assert_eq(contains_owner, owner);

        //Destroy name and owner mapping
        Mapping::remove(nft_owners, ansHash);
        Mapping::remove(name_to_owner, name);
        Mapping::remove(name_info, name);

        // check is owner set already primary_name and primary name is same as name if yes remove it
        let contains_primary_name: bool = Mapping::contains(primary_name, owner);
        if (contains_primary_name == true) {
            let primary_name_value: Name = Mapping::get(primary_name, owner);
            if (primary_name_value == name) {
                Mapping::remove(primary_name, owner);
            }
        }
    }



    // Transfer public the NFT to another user
    transition transfer_public(
        public nft: NFT,
        public receiver: address,
    ) -> NFT {

        let ansHash: field = BHP256::hash_to_field(nft.name);

        return NFT {
            owner: receiver,
            data: nft.data,
            edition: nft.edition + 1scalar,
            name: nft.name,
            end_time: nft.end_time
        } then finalize(self.caller, receiver, ansHash, nft.name, nft.end_time, nft.data);
    }

    finalize transfer_public(sendler: address, receiver: address, ansHash: field, name: Name, end_time: u64, data: TokenId) {
        // Ensure collection is initialized and not frozen.
        let is_initialized_and_not_frozen: u32 = toggle_settings.get_or_use(0u8, 1u32);
        assert_eq(is_initialized_and_not_frozen, 1u32);

        let contains_nameHash: bool = Mapping::contains(nft_owners, ansHash);
        assert_eq(contains_nameHash, true); // name is already registered to somebody else

        let contains_name: bool = Mapping::contains(name_to_owner, name);
        assert_eq(contains_name, true); // name is already registered to somebody else



        //remove from primary name if sendler is owner as primary name
        let contains_primary_name: bool = Mapping::contains(primary_name, sendler);
        if (contains_primary_name == true) {
            let primary_name_value: Name = Mapping::get(primary_name, sendler);
            if (primary_name_value == name) {
                Mapping::remove(primary_name, sendler);
            }
        }


        // Set name and owner mapping
        nft_owners.set(ansHash, receiver);
        name_to_owner.set(name, receiver);
        name_info.set(name, AleoNameService {ans_owner: receiver, name: name, end_time: end_time, data: data});


        // check is owner set already primary_name if not set it
        let contains_owner: bool = Mapping::contains(primary_name, receiver);
        if (contains_owner == false) {
            primary_name.set(receiver, name);
        }
    }

}

// Offical Hikuru Aleo Domain - https://hikuru.com 