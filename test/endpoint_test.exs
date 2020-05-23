defmodule Pokemon.Web.EndpointTest do
  use ExUnit.Case

  @http_port Pokemon.Web.Endpoint.port()

  @ditto_translated_description "Ditto rearranges its cell structure to transform itself into other shapes. " <>
                                  "However,  if 't be true 't tries to transform itself into something by relying on its memory,  " <>
                                  "this pokémon manages to receiveth details wrong."

  describe "test pokemon api IT" do
    @tag :integration_test
    test "ditto" do
      name = "ditto"

      assert {:ok, %{body: body, status_code: 200}} =
               HTTPoison.get("http://localhost:#{@http_port}/pokemon/#{name}")

      assert body == ~s({"description":"#{@ditto_translated_description}","name":"#{name}"})
    end

    @tag :integration_test
    test "unknown" do
      name = "unknown"

      assert {:ok, %{status_code: 404}} =
               HTTPoison.get("http://localhost:#{@http_port}/pokemon/#{name}")
    end
  end
end
