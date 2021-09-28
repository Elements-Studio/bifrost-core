//! account: alice, 100000 0x1::STC::STC
//! account: joe
//! account: admin, 0x569AB535990a17Ac9Afd1bc57Faec683, 300000 0x1::STC::STC


//! new-transaction
//! sender: admin
script {
    use 0x569AB535990a17Ac9Afd1bc57Faec683::Bifrost;
    use 0x1::STC::STC;
    fun register_token_box(signer: signer) {
        //token pair register must be swap admin account
        Bifrost::register_token_box<STC>(&signer);
    }
}
// check: EXECUTED


//! new-transaction
//! sender: alice
address alice = {{alice}};
script{
    use 0x1::STC::STC;
    use 0x1::Account;
    use 0x569AB535990a17Ac9Afd1bc57Faec683::Bifrost;

    fun main(signer: signer) {
        let amount: u128 = 50000;
        let to_address: vector<u8> = x"a7BBa351F619935E12DAB2be27e871994e6Da02D";
        let to_chain = 1;
        Bifrost::transfer_to_ethereum_chain<STC>(&signer, to_address, amount, to_chain);

        let balance = Account::balance<STC>(@alice);
        assert(balance == (100000 - amount), 10001);
    }
}
// check: EXECUTED


//! new-transaction
//! sender: admin
address alice = {{alice}};
script{
    use 0x1::STC::STC;
    use 0x1::Account;
    use 0x569AB535990a17Ac9Afd1bc57Faec683::Bifrost;

    fun main(signer: signer) {
        let amount: u128 = 30000;
        let from_address: vector<u8> = x"a7BBa351F619935E12DAB2be27e871994e6Da02D";
        let to_address = @alice;
        let from_chain = 1;
        Bifrost::withdraw_from_ethereum_chain<STC>(&signer, from_address, to_address, amount, from_chain);

        let balance = Account::balance<STC>(@alice);
        assert(balance == (100000 - 50000 + amount), 10002);
    }
}
// check: EXECUTED