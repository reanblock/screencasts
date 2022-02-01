const Wallet = require('ethereumjs-wallet');

const EthWallet = Wallet.default.generate();

console.log("Private Key: ", EthWallet.getPrivateKeyString())
console.log("Address: ", EthWallet.getAddressString())