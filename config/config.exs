use Mix.Config

config :pokemon, Pokemon.Web.Endpoint, port: 5000

config :logger, :console,
  format: "$date $time [$level] $message $metadata\n",
  metadata: [:error, :name]

import_config "#{Mix.env()}.exs"
