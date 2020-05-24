use Mix.Config

config :pokemon, Pokemon.Web.Endpoint, port: 5000

config :pokemon, :pokeapi,
  pokemon_url: "https://pokeapi.co/api/v2/pokemon",
  pokemon_species_url: "https://pokeapi.co/api/v2/pokemon-species",
  version: "alpha-sapphire",
  language: "en"

config :pokemon, :funtranslations,
  shakespeare_url: "https://api.funtranslations.com/translate/shakespeare.json",
  headers: %{"Content-Type" => "application/x-www-form-urlencoded"}

config :logger, :console,
  format: "$date $time [$level] $message $metadata\n",
  metadata: [:error, :name]

import_config "#{Mix.env()}.exs"
