# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :data_diff, DataDiffWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7gp83ws2rRsi+avdsunGmN4o0z/Q+lvkU5eAxgVP/4FpLfs1EWPAo8WmCC8sJm5A",
  render_errors: [view: DataDiffWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: DataDiff.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, DataDiff.Router,
  parsers: [parsers: [:urlencoded, :multipart, :json],
    accept: ["*/*"],
    json_decoder: Poison,
    length: 100_000_000]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
