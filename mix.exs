defmodule Pokemon.MixProject do
  use Mix.Project

  def project do
    [
      app: :pokemon,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pokemon.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:mock, "~> 0.3"},
      # web
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.4"}
    ]
  end

  defp aliases do
    [
      c: "compile",
      "format.all": "format mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}' 'config/*.{ex,exs}'"
    ]
  end
end
