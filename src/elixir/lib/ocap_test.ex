defmodule OcapTest do
  @moduledoc false

  @btc_api "https://ocap.arcblock.io/api/btc"

  def query do
    Neuron.Config.set(url: @btc_api)

    response =
      Neuron.query("""
      {
        accountByAddress(address: "1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX") {
          address
          balance
          pubKey
          scriptType
          subKeys
        }
      }
      """)

    case response do
      {:ok, %{body: body}} -> body
      _ -> :error
    end
  end
end
