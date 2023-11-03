import credits.aleo;
program ans_v2.aleo;


struct TokenId:
    data1 as u128;
    data2 as u128;

struct BaseURI:
    data0 as u128;
    data1 as u128;
    data2 as u128;
    data3 as u128;

struct Name:
    data0 as u128;
    data1 as u128;
    data2 as u128;
    data3 as u128;

struct SymbolBits:
    data as u128;

record NFT:
    owner as address.private;
    data as TokenId.private;
    edition as scalar.private;
    name as Name.private;
    end_time as u64.private;

struct AleoNameService:
    ans_owner as address;
    name as Name;
    end_time as u64;
    data as TokenId;


mapping toggle_settings:
	key as u8.public;
	value as u32.public;


mapping general_settings:
	key as u8.public;
	value as u128.public;


mapping nft_owners:
	key as field.public;
	value as address.public;


mapping name_to_owner:
	key as Name.public;
	value as address.public;


mapping primary_name:
	key as address.public;
	value as Name.public;


mapping name_info:
	key as Name.public;
	value as AleoNameService.public;

function initialize_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as BaseURI.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;
    async initialize_collection r0 r1 r2 into r3;
    output r3 as ans_v2.aleo/initialize_collection.future;

finalize initialize_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as BaseURI.public;
    get.or_use toggle_settings[0u8] 0u32 into r3;
    assert.eq r3 0u32;
    set 0u128 into general_settings[0u8];
    set r0 into general_settings[1u8];
    set r1 into general_settings[2u8];
    set r2.data0 into general_settings[3u8];
    set r2.data1 into general_settings[4u8];
    set r2.data2 into general_settings[5u8];
    set r2.data3 into general_settings[6u8];
    set 5u32 into toggle_settings[0u8];
    set 0u32 into toggle_settings[1u8];


function update_base_uri:
    input r0 as BaseURI.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;
    async update_base_uri r0 into r1;
    output r1 as ans_v2.aleo/update_base_uri.future;

finalize update_base_uri:
    input r0 as BaseURI.public;
    get.or_use toggle_settings[0u8] 1u32 into r1;
    assert.eq r1 1u32;
    set r0.data0 into general_settings[3u8];
    set r0.data1 into general_settings[4u8];
    set r0.data2 into general_settings[5u8];
    set r0.data3 into general_settings[6u8];


function update_toggle_settings:
    input r0 as u32.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;
    async update_toggle_settings r0 into r1;
    output r1 as ans_v2.aleo/update_toggle_settings.future;

finalize update_toggle_settings:
    input r0 as u32.public;
    get toggle_settings[0u8] into r1;
    and r1 9u32 into r2;
    assert.eq r2 1u32;
    and r0 1u32 into r3;
    assert.eq r3 1u32;
    set r0 into toggle_settings[0u8];


function register_public:
    input r0 as Name.public;
    input r1 as u64.public;
    input r2 as u64.public;
    input r3 as u64.public;
    assert.eq r2 0u64;
    call credits.aleo/transfer_public aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl 49_000_000u64;
    hash.bhp256 r0 into r4 as field;
    mul r2 30u64 into r5;
    mul r5 24u64 into r6;
    mul r6 60u64 into r7;
    mul r7 60u64 into r8;
    add r1 r8 into r9;
    cast 0u128 0u128 into r10 as TokenId;
    cast self.caller r10 0scalar r0 r9 into r11 as NFT.record;
    async register_public self.caller r0 r9 r4 r2 r3 into r12;
    output r11 as NFT.record;
    output r12 as ans_v2.aleo/register_public.future;

finalize register_public:
    input r0 as address.public;
    input r1 as Name.public;
    input r2 as u64.public;
    input r3 as field.public;
    input r4 as u64.public;
    input r5 as u64.public;
    get.or_use toggle_settings[0u8] 1u32 into r6;
    assert.eq r6 1u32;
    contains nft_owners[r3] into r7;
    assert.eq r7 true;
    contains name_to_owner[r1] into r8;
    assert.eq r8 true;
    set r0 into nft_owners[r3];
    set r0 into name_to_owner[r1];
    cast 0u128 0u128 into r9 as TokenId;
    cast r0 r1 r2 r9 into r10 as AleoNameService;
    set r10 into name_info[r1];
    contains primary_name[r0] into r11;
    is.eq r11 false into r12;
    set r1 into primary_name[r0];


function register_private:
    input r0 as Name.public;
    input r1 as u64.public;
    input r2 as u64.public;
    input r3 as u64.public;
    input r4 as credits.aleo/credits.record;
    assert.eq r2 0u64;
    call credits.aleo/transfer_private_to_public r4 aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl 49_000_000u64 into r5;
    hash.bhp256 r0 into r6 as field;
    mul r2 30u64 into r7;
    mul r7 24u64 into r8;
    mul r8 60u64 into r9;
    mul r9 60u64 into r10;
    add r1 r10 into r11;
    cast 0u128 0u128 into r12 as TokenId;
    cast self.caller r12 0scalar r0 r11 into r13 as NFT.record;
    async register_private self.caller r0 r11 r6 r2 r3 into r14;
    output r13 as NFT.record;
    output r5 as credits.aleo/credits.record;
    output r14 as ans_v2.aleo/register_private.future;

finalize register_private:
    input r0 as address.public;
    input r1 as Name.public;
    input r2 as u64.public;
    input r3 as field.public;
    input r4 as u64.public;
    input r5 as u64.public;
    get.or_use toggle_settings[0u8] 1u32 into r6;
    assert.eq r6 1u32;
    contains nft_owners[r3] into r7;
    assert.eq r7 true;
    contains name_to_owner[r1] into r8;
    assert.eq r8 true;
    set r0 into nft_owners[r3];
    set r0 into name_to_owner[r1];
    cast 0u128 0u128 into r9 as TokenId;
    cast r0 r1 r2 r9 into r10 as AleoNameService;
    set r10 into name_info[r1];
    contains primary_name[r0] into r11;
    is.eq r11 false into r12;
    set r1 into primary_name[r0];


function set_primary_name:
    input r0 as Name.private;
    async set_primary_name self.caller r0 into r1;
    output r1 as ans_v2.aleo/set_primary_name.future;

finalize set_primary_name:
    input r0 as address.public;
    input r1 as Name.public;
    get name_to_owner[r1] into r2;
    assert.neq r2 r0;
    set r1 into primary_name[r0];


function burn:
    input r0 as Name.public;
    hash.bhp256 r0 into r1 as field;
    async burn self.caller r0 r1 into r2;
    output r2 as ans_v2.aleo/burn.future;

finalize burn:
    input r0 as address.public;
    input r1 as Name.public;
    input r2 as field.public;
    get.or_use toggle_settings[0u8] 1u32 into r3;
    assert.eq r3 1u32;
    get nft_owners[r2] into r4;
    assert.eq r4 r0;
    remove nft_owners[r2];
    remove name_to_owner[r1];
    remove name_info[r1];
    contains primary_name[r0] into r5;
    is.eq r5 true into r6;
    get primary_name[r0] into r7;
    is.eq r7 r1 into r8;
    remove primary_name[r0];


function transfer:
    input r0 as NFT.record;
    input r1 as address.public;
    hash.bhp256 r0.name into r2 as field;
    add r0.edition 1scalar into r3;
    cast r1 r0.data r3 r0.name r0.end_time into r4 as NFT.record;
    async transfer self.caller r1 r2 r0.name r0.end_time r0.data into r5;
    output r4 as NFT.record;
    output r5 as ans_v2.aleo/transfer.future;

finalize transfer:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as field.public;
    input r3 as Name.public;
    input r4 as u64.public;
    input r5 as TokenId.public;
    get.or_use toggle_settings[0u8] 1u32 into r6;
    assert.eq r6 1u32;
    contains nft_owners[r2] into r7;
    assert.eq r7 true;
    contains name_to_owner[r3] into r8;
    assert.eq r8 true;
    contains primary_name[r0] into r9;
    is.eq r9 true into r10;
    get primary_name[r0] into r11;
    is.eq r11 r3 into r12;
    remove primary_name[r0];
    set r1 into nft_owners[r2];
    set r1 into name_to_owner[r3];
    cast r1 r3 r4 r5 into r13 as AleoNameService;
    set r13 into name_info[r3];
    contains primary_name[r1] into r14;
    is.eq r14 false into r15;
    set r3 into primary_name[r1];
