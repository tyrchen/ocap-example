from graphqlclient import GraphQLClient

client = GraphQLClient('https://ocap.arcblock.io/api/btc')

result = client.execute('''
{
  accountByAddress(address: "1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX") {
    address
    balance
    pubKey
    scriptType
    subKeys
  }
}
''')

print(result)
