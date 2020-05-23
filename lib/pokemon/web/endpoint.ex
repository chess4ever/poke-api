defmodule Pokemon.Web.Endpoint do
  use Plug.Router

  require Logger

  @http_port :pokemon |> Application.fetch_env!(__MODULE__) |> Keyword.fetch!(:port)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  forward("/pokemon/:name", to: Pokemon.Web.Router)

  match _ do
    send_resp(conn, 404, "Not found")
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    Logger.info("Starting server at http://localhost:#{@http_port}")
    Plug.Cowboy.http(__MODULE__, [], port: @http_port)
  end

  def port, do: @http_port
end
