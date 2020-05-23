defmodule Pokemon.Web.Router do
  use Plug.Router

  alias Pokemon.PokemonClient
  alias Pokemon.ShakespeareClient

  require Logger

  plug(:match)
  plug(:dispatch)

  get "/" do
    name = conn.params["name"]
    Logger.info("Received call for pokemon #{name}")

    get_response(conn, name)
  end

  defp get_response(conn, name) do
    with {:ok, description} <- PokemonClient.get_description_by_name(name),
         {:ok, translated} <- ShakespeareClient.translate(description) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(message(conn.params["name"], translated)))
    else
      {:error, :pokemon_not_found} ->
        send_resp(conn, 404, "Not found")

      {:error, :rate_limit_exceeded} ->
        send_resp(conn, 429, "Rate limit exceeded")

      e ->
        Logger.error("Unexpected error, #{inspect(e)}")
        send_resp(conn, 500, "Unexpected error")
    end
  end

  defp message(name, description) do
    %{
      name: name,
      description: description
    }
  end
end
