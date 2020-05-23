defmodule ShakespeareClientTest do
  use ExUnit.Case

  alias Pokemon.ShakespeareClient

  import Mock

  describe "translate description" do
    test "charizard" do
      text = "Charizard flies around the sky in search of powerful opponents"
      expected_translated_text = "Charizard flies 'round the sky in search of powerful opponents"

      with_mock HTTPoison,
        post: fn _, "text=" <> ^text, _ -> mock_response(text, expected_translated_text) end do
        assert {:ok, translated_text} = ShakespeareClient.translate(text)
        assert translated_text =~ expected_translated_text
      end
    end

    test "bulbasaur" do
      text = "Bulbasaur can be seen napping in bright sunlight."
      expected_translated_text = "Bulbasaur can beest seen napping in bright sunlight."

      with_mock HTTPoison,
        post: fn _, "text=" <> ^text, _ -> mock_response(text, expected_translated_text) end do
        assert {:ok, translated_text} = ShakespeareClient.translate(text)
        assert translated_text =~ expected_translated_text
      end
    end
  end

  describe "translate description IT" do
    @tag :integration_test
    test "charizard" do
      assert {:ok, translated_text} =
               ShakespeareClient.translate(
                 "Charizard flies around the sky in search of powerful opponents"
               )

      assert translated_text =~ "Charizard flies 'round the sky in search of powerful opponents"
    end
  end

  defp mock_response(text, translated_text) do
    {:ok,
     %HTTPoison.Response{
       body:
         "{\n    \"success\": {\n        \"total\": 1\n    },\n    \"contents\": {\n        \"translated\": \"#{
           translated_text
         }\",\n        \"text\": \"#{text}\",\n        \"translation\": \"shakespeare\"\n    }\n}",
       status_code: 200
     }}
  end
end
