const Web3 = require('web3');
const web3 = new Web3('https://mainnet.infura.io/v3/');
// Signer 
const private_key = "0x11111111111111111111111111111111aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab" 
const account = web3.eth.accounts.privateKeyToAccount(private_key); 
const address = account.address; 
console.log('address:', address)
function signMsg(address, userId, nonce , blockNumber){
    const hash = web3.utils.keccak256(
        web3.eth.abi.encodeParameters(
            ['address', 'uint256', 'uint256', 'uint256'],
            [address, userId, nonce, blockNumber]
        )
    );
    const signature = web3.eth.accounts.sign(hash, private_key);
    console.log('signature:', signature)
    return {
        v: signature.v,
        r: signature.r,
        s: signature.s
    }
}
signMsg("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", 1, 1, 1700288495)
