# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ocap_test,
  ecto_repos: [OcapTest.Repo]

# Configures the endpoint
config :ocap_test, OcapTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XUczW+yfmFDiqDY+3aete2spe1shWRA+P4mBj+DzApHCkdN04k9Q+c7LTHhWEakX",
  render_errors: [view: OcapTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OcapTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
