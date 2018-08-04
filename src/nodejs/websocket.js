const { Socket } = require('phoenix-channels')

let socket = new Socket("wss://ocap.arcblock.io/api/socket");

socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel('__absinthe__:control');

const query = "subscription { \n  newBlockMined { \n    hash\n }\n}";

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
    channel.push("doc", { query: query })
      .receive("ok", resp => {
        console.log(resp);
        channel.on(resp, resp => {
          console.log(resp);
        })
      })
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

socket.onMessage(({ event, payload, ref }) => {
  if (event === "subscription:data") {
    console.log(payload.result.data);
  }

});
