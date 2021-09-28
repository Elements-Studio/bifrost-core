address 0x569AB535990a17Ac9Afd1bc57Faec683 {

/// Bifrost Token used for Mapping ethereum ERC20 tokens
module BifrostToken {
    use 0x1::Signer;
    use 0x1::Token;
    use 0x1::Account;

    /// Bifrost token marker.
    struct BifrostToken has copy, drop, store {}

    struct TokenCapability<BifrostToken> has key, store {
        mint: Token::MintCapability<BifrostToken>,
        burn: Token::BurnCapability<BifrostToken>,
    }

    /// Bifrost token default precision of token.
    const PRECISION: u8 = 18;

    /// Bifrost initialization.
    public fun init(account: &signer) {
        // TODO need check token exists
        Token::register_token<BifrostToken>(account, PRECISION);
        Account::do_accept_token<BifrostToken>(account);

        let mint_capability = Token::remove_mint_capability<BifrostToken>(account);
        let burn_capability = Token::remove_burn_capability<BifrostToken>(account);
        move_to(account, TokenCapability { mint: mint_capability, burn: burn_capability });
    }

    public fun mint(account: &signer, amount: u128) acquires TokenCapability {
        let mint_cap = borrow_global<TokenCapability<BifrostToken>>(admin_address());
        let mint_token = Token::mint_with_capability(&mint_cap.mint, amount);
        if (!Account::is_accepts_token<BifrostToken>(Signer::address_of(account))) {
            Account::do_accept_token<BifrostToken>(account);
        };
        Account::deposit(Signer::address_of(account), mint_token);
    }

    fun admin_address(): address {
        @0x569AB535990a17Ac9Afd1bc57Faec683
    }
}
}