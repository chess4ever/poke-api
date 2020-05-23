defmodule Pokemon.PokemonClient do
  @moduledoc """
  Documentation for `Pokemon`.
  """

  require Logger

  @pokemon_url "https://pokeapi.co/api/v2/pokemon"
  @pokemon_species_url "https://pokeapi.co/api/v2/pokemon-species"
  @pokemon_version "alpha-sapphire"
  @language "en"

  @not_found_message :pokemon_not_found

  def get_description_by_name(name) do
    with {:ok, id} <- get_id_by_name(name) do
      get_description(id)
    end
  end

  def get_description(id) do
    get_data(
      "#{@pokemon_species_url}/#{id}",
      &find_description_by_version_and_language(&1, @pokemon_version, @language),
      id: id
    )
  end

  def get_id_by_name(name) do
    get_data(
      "#{@pokemon_url}/#{name}",
      &find_id/1,
      name: name
    )
  end

  defp get_data(url, parse_fun, metadata) do
    with {:ok, %{body: body}} <-
           HTTPoison.get(url),
         {:ok, data} <- Jason.decode(body) do
      parse_fun.(data)
    else
      {:ok, %HTTPoison.Response{status_code: 429, body: body}} ->
        Logger.warn("Rate limit exceeded", error: inspect(body))
        {:error, :rate_limit_exceeded}

      _ ->
        Logger.info("Pokemon not found", metadata)
        {:error, @not_found_message}
    end
  end

  defp find_id(%{"id" => id}), do: {:ok, id}

  defp find_description_by_version_and_language(
         %{"flavor_text_entries" => text_entries},
         version,
         language
       ) do
    %{"flavor_text" => desc} =
      Enum.find(
        text_entries,
        &(get_in(&1, ["version", "name"]) == version and
            get_in(&1, ["language", "name"]) == language)
      )

    {:ok, desc}
  end
end
