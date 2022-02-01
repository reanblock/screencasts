const { publicKeyCreate } = require('secp256k1');

const privateKey = '99E7A19CC1B9A616D45981C991869AEE759B8EC8C6906DB2257CA393C20937DC';

const privateKeyBuffer = Buffer.from(privateKey, 'hex');

const publicKey = Buffer.from(publicKeyCreate(privateKeyBuffer, false)).toString('hex');

console.log('Public Key: ', publicKey);

//2603fc985787492d8d4b0e529c8a8c7aa1e6972531006cfefd851a474c9b2ad437d2bb59dc114013048e3d99bf3ea99deace62dad6dd7be8418f3ea6de825f00