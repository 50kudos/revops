# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :revops,
  ecto_repos: [Revops.Repo]

# Configures the endpoint
config :revops, RevopsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aEMTxJvgUuSh/hy3E3FRvvD+mfH/rK/VZlW1CAIUm2gVEfYMTN8e7K1IWqIxp2Ol",
  render_errors: [view: RevopsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Revops.PubSub,
  live_view: [signing_salt: "7CcuXn4f"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
