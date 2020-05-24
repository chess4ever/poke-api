defmodule Pokemon.ShakespeareClient do
  require Logger

  @funtranslations_config Application.fetch_env!(:pokemon, :funtranslations)
  @shakespeare_url Keyword.fetch!(@funtranslations_config, :shakespeare_url)
  @headers Keyword.fetch!(@funtranslations_config, :headers)

  def translate(text) do
    with {:ok, %{body: body, status_code: 200}} <-
           HTTPoison.post("#{@shakespeare_url}", "text=#{text}", @headers),
         {:ok, data} <- Jason.decode(body) do
      get_translation(data)
    else
      {:ok, %HTTPoison.Response{status_code: 429, body: body}} ->
        Logger.warn("Rate limit exceeded", error: inspect(body))
        {:error, :rate_limit_exceeded}

      e ->
        Logger.error("Unexpected error while translating text", error: inspect(e))
        {:error, :problem_translating_text}
    end
  end

  defp get_translation(%{"contents" => %{"translated" => translated_text}}),
    do: {:ok, translated_text}
end
