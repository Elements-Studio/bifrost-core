address 0x569AB535990a17Ac9Afd1bc57Faec683 {

module Bifrost {
    use 0x1::Signer;
    use 0x1::Account;
    use 0x1::Token;
    use 0x1::Event;
    use 0x1::Vector;
    use 0x1::Errors;

    struct TokenBox<T> has key, store  {
        token_locked: Token::Token<T>,
        cross_chain_deposit_event: Event::EventHandle<CrossChainDepositEvent>,
        cross_chain_withdraw_event: Event::EventHandle<CrossChainWithdrawEvent>,
    }

    /// Event emitted when transfer token from starcoin to ETHEREUM chain.
    struct CrossChainDepositEvent has drop, store {
        /// token code of T type
        token_code: Token::TokenCode,
        /// of starcoin addrsss
        from: address,
        /// of ethereum addrsss
        to: vector<u8>,
        owner: address,
        value: u128,
        to_chain: u8,
    }

    /// Event emitted when withdraw token from ethereum to starcoin chain.
    struct CrossChainWithdrawEvent has drop, store {
        /// token code of T type
        token_code: Token::TokenCode,
        /// of ethereum addrsss
        from: vector<u8>,
        /// of starcoin addrsss
        to: address,
        owner: address,
        value: u128,
        from_chain: u8,
    }

    /// ethereum chain encode
    const CHAIN_ETHEREUM:u8 = 1;
    const CHAIN_BSC:u8 = 2;
    const CHAIN_HECO:u8 = 3;

    /// error code
    const ERROR_BIFROST_PRIVILEGE_INSUFFICIENT: u64 = 2101;
    const ERROR_INVALID_ETHEREUM_ADDRESS: u64 = 2102;

    /// must by register by admin
    public fun register_token_box<T: store>(signer: &signer) {
        assert_admin(signer);
        let token_box = TokenBox<T> {
            token_locked: Token::zero<T>(),
            cross_chain_deposit_event: Event::new_event_handle<CrossChainDepositEvent>(signer),
            cross_chain_withdraw_event: Event::new_event_handle<CrossChainWithdrawEvent>(signer),
        };
        move_to(signer, token_box);
    }


    public fun transfer_to_ethereum_chain<T: store>(signer: &signer, to: vector<u8>, amount: u128, to_chain: u8):() acquires TokenBox{
        assert(Vector::length(&to) == 20, Errors::invalid_argument(ERROR_INVALID_ETHEREUM_ADDRESS));
        let token = Account::withdraw<T>(signer, amount);
        let token_box = borrow_global_mut<TokenBox<T>>(admin_address());
        Token::deposit(&mut token_box.token_locked, token);
        Event::emit_event(&mut token_box.cross_chain_deposit_event, CrossChainDepositEvent {
            token_code: Token::token_code<T>(),
            from: Signer::address_of(signer),
            to: to, //ethereum address
            owner: admin_address(),
            value: amount,
            to_chain: to_chain,
        });
    }

    ///must be call only by admin
    public fun withdraw_from_ethereum_chain<T: store>(signer: &signer, from: vector<u8>, to: address, amount: u128, from_chain: u8):() acquires TokenBox{
        assert_admin(signer);
        assert(Vector::length(&from) == 20, Errors::invalid_argument(ERROR_INVALID_ETHEREUM_ADDRESS));
        let token_box = borrow_global_mut<TokenBox<T>>(admin_address());
        let token = Token::withdraw(&mut token_box.token_locked, amount);
        Account::deposit(to, token);
        Event::emit_event(&mut token_box.cross_chain_withdraw_event, CrossChainWithdrawEvent {
            token_code: Token::token_code<T>(),
            from: from, //ethereum address
            to: to,
            owner: admin_address(),
            value: amount,
            from_chain: from_chain,
        });
    }

    fun assert_admin(signer: &signer) {
        assert(Signer::address_of(signer) == admin_address(), ERROR_BIFROST_PRIVILEGE_INSUFFICIENT);
    }

    fun admin_address(): address {
        @0x569AB535990a17Ac9Afd1bc57Faec683
    }
}

module STCTokenBox{
    use 0x569AB535990a17Ac9Afd1bc57Faec683::Bifrost;
    use 0x1::STC::STC;

    public fun register(signer: &signer){
        Bifrost::register_token_box<STC>(signer);
    }
}

}