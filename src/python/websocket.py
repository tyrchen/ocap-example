from chunnel import Socket

query = "subscription { \n  newBlockMined { \n    hash\n }\n}"

async def listen():
  socket = Socket('wss://ocap.arcblock.io/api/socket/websocket', {})
  async with socket:
    channel = socket.channel('__absinthe__:control', {})
    response = await channel.join()
    print("Joined:", response)
    response = await channel.push('doc', {'query': query})
    print("Topic listened:", await response.response())
    message = await channel.receive()
    data = message.payload['result']['data']
    print(data)

def main():
  import asyncio
  loop = asyncio.get_event_loop()
  loop.run_until_complete(listen())
  loop.run_forever()

if __name__ == '__main__':
  main()


# 16:23:35.436 application=absinthe module=Absinthe.Subscription.Local function=run_docset/2 [debug] AbsintheSubscription Publication
# Field Topic: {:new_block_mined, :new_block}
# Subscription id: "__absinthe__:doc:80613059"
# Data: %{data: %{"newBlockMined" => %{"hash" => "0xf577a1973cbd7cf3936e4ab4c289d9d3d3cfff7e0e29d55ad8b7e64fc88c38f7"}}}
