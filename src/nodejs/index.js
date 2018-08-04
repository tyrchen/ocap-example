const { request } = require('graphql-request');

const query = `query ($address: String!) {
  accountByAddress(address: $address) {
    address
    balance
    pubKey
    scriptType
    subKeys
  }
}`;

const variables = { address: '1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX' };

request('https://ocap.arcblock.io/api/btc', query, variables).then(data => console.log(data));
