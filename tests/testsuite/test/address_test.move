//! account: alice, 100000 0x1::STC::STC
//! account: joe


//! new-transaction
//! sender: alice
script {
    use 0x1::Vector;
    fun main(_signer: signer) {
        let ethereum_address:vector<u8> = x"a7BBa351F619935E12DAB2be27e871994e6Da02D";
        let starcoin_address:vector<u8> = x"1656458E740A96c7aC84eA5D39F89829";
        assert(Vector::length(&ethereum_address) == 20, 10003);
        assert(Vector::length(&starcoin_address) == 16, 10004);

        // the below syntax will encounter  MoveSourceCompilerError
//        let ethereum_address_0x:vector<u8> = "0xa7BBa351F619935E12DAB2be27e871994e6Da02D";
//        let starcoin_address_0x:vector<u8> = "0x1656458E740A96c7aC84eA5D39F89829";
//        assert(Vector::length(&ethereum_address_0x) == 21, 10005);
//        assert(Vector::length(&starcoin_address_0x) == 17, 10006);
    }
}
// check: EXECUTED