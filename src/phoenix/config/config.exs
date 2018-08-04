# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix,
  ecto_repos: [Phoenix.Repo]

# Configures the endpoint
config :phoenix, PhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y+QTN4xK2SvQMoBY6Fn6D40d56zsAqhJsD0l0+kBHmy+9Rt9txoDEoB5HLN6MBBQ",
  render_errors: [view: PhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
