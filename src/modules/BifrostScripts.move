address 0x569AB535990a17Ac9Afd1bc57Faec683 {
module BifrostScripts{
    use 0x569AB535990a17Ac9Afd1bc57Faec683::Bifrost;

    public(script) fun register_token_box<T: store>(signer: signer)  {
        Bifrost::register_token_box<T>(&signer);
    }

    public(script) fun transfer_to_ethereum_chain<T: store>(signer: signer, to: vector<u8>, amount: u128, to_chain: u8)  {
        Bifrost::transfer_to_ethereum_chain<T>(&signer, to, amount, to_chain);
    }

    public(script) fun withdraw_from_ethereum_chain<T: store>(signer: signer, from: vector<u8>, to: address, amount: u128, from_chain: u8) {
        Bifrost::withdraw_from_ethereum_chain<T>(&signer, from, to, amount, from_chain);
    }
}

}