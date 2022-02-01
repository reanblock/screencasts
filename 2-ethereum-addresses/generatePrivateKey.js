const crypto = require('crypto');

const privateKey = crypto.randomBytes(32).toString('hex');

console.log('Private Key: ', privateKey);