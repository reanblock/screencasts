const keccak256 = require('keccak256');

const publicKey = '2603fc985787492d8d4b0e529c8a8c7aa1e6972531006cfefd851a474c9b2ad437d2bb59dc114013048e3d99bf3ea99deace62dad6dd7be8418f3ea6de825f00';

const publicKeyBuffer = Buffer.from(publicKey, 'hex');

const ethereumAddress = keccak256(publicKeyBuffer).toString('hex').slice(64 - 40);

console.log('Ethereum Address: ', '0x' + ethereumAddress);