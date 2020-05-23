defmodule PokemonClientTest do
  use ExUnit.Case
  doctest Pokemon

  alias Pokemon.PokemonClient

  import Mock

  @pokemon_url "https://pokeapi.co/api/v2/pokemon"
  @pokemon_species_url "https://pokeapi.co/api/v2/pokemon-species"

  @charizard_description "Charizard flies around the sky in search of powerful opponents"
  @bulbasaur_description "Bulbasaur can be seen napping in bright sunlight."

  describe "get pokemon description by id" do
    test "charizard" do
      id = 6
      url = "#{@pokemon_species_url}/#{id}"
      desc = @charizard_description

      with_mock HTTPoison,
        get: fn ^url -> mock_response(desc) end do
        assert {:ok, description} = PokemonClient.get_description(id)
        assert description =~ desc
      end
    end

    test "bulbasaur" do
      id = 1
      url = "#{@pokemon_species_url}/#{id}"
      desc = @bulbasaur_description

      with_mock HTTPoison,
        get: fn ^url -> mock_response(desc) end do
        assert {:ok, description} = PokemonClient.get_description(id)
        assert description =~ desc
      end
    end

    test "unknown pokemon" do
      assert {:error, :pokemon_not_found} = PokemonClient.get_description(0)

      id = 0
      url = "#{@pokemon_species_url}/#{id}"

      with_mock HTTPoison,
        get: fn ^url -> mock_response_ko() end do
        assert {:error, :pokemon_not_found} = PokemonClient.get_description(id)
      end
    end
  end

  describe "get pokemon id by name" do
    test "charizard" do
      id = 6
      name = "charizard"
      url = "#{@pokemon_url}/#{name}"

      with_mock HTTPoison,
        get: fn ^url -> mock_response_pokemon(id) end do
        assert {:ok, ^id} = PokemonClient.get_id_by_name(name)
      end
    end

    test "bulbasaur" do
      id = 1
      name = "bulbasaur"
      url = "#{@pokemon_url}/#{name}"

      with_mock HTTPoison,
        get: fn ^url -> mock_response_pokemon(id) end do
        assert {:ok, ^id} = PokemonClient.get_id_by_name(name)
      end
    end

    test "pokemon" do
      name = "pokemon"
      url = "#{@pokemon_url}/#{name}"

      with_mock HTTPoison,
        get: fn ^url -> mock_response_ko() end do
        assert {:error, :pokemon_not_found} = PokemonClient.get_id_by_name(name)
      end
    end
  end

  describe "get description by name" do
    test "charizard" do
      id = 6
      name = "charizard"
      description = @charizard_description

      with_mock PokemonClient, [:passthrough],
        get_id_by_name: fn ^name -> id end,
        get_description: fn ^id -> description end do
        assert {:ok, description} = PokemonClient.get_description_by_name(name)
        assert description =~ description
      end
    end

    test "bulbasaur" do
      id = 1
      name = "bulbasaur"
      description = @bulbasaur_description

      with_mock PokemonClient, [:passthrough],
        get_id_by_name: fn ^name -> id end,
        get_description: fn ^id -> description end do
        assert {:ok, description} = PokemonClient.get_description_by_name(name)
        assert description =~ description
      end
    end

    test "pokemon" do
      error = {:error, :pokemon_not_found}

      name = "bulbasaur"

      with_mock PokemonClient, [:passthrough], get_id_by_name: fn ^name -> {:error} end do
        assert ^error = PokemonClient.get_description_by_name("pokemon")
      end
    end
  end

  describe "get description by name IT" do
    @tag :integration_test
    test "charizard" do
      assert {:ok, description} = PokemonClient.get_description_by_name("charizard")
      assert description =~ @charizard_description
    end

    @tag :integration_test

    test "bulbasaur" do
      assert {:ok, description} = PokemonClient.get_description_by_name("bulbasaur")
      assert description =~ @bulbasaur_description
    end

    @tag :integration_test

    test "pokemon" do
      assert {:error, :pokemon_not_found} = PokemonClient.get_description_by_name("pokemon")
    end
  end

  defp mock_response(description) do
    {:ok,
     %HTTPoison.Response{
       body:
         ~s({"flavor_text_entries":[{"flavor_text":"強い　相手を　求めて　空を　飛び回る。\\nなんでも　溶かして　しまう　高熱の　炎を\\n自分より　弱いものに　向けることは　しない。","language":{"name":"ja","url":"https://pokeapi.co/api/v2/language/11/"},"version":{"name":"alpha-sapphire","url":"https://pokeapi.co/api/v2/version/26/"}},{"flavor_text":"#{
           description
         }","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"version":{"name":"alpha-sapphire","url":"https://pokeapi.co/api/v2/version/26/"}}]}),
       status_code: 200
     }}
  end

  defp mock_response_pokemon(id) do
    {:ok,
     %HTTPoison.Response{
       body: ~s({"id":#{id}}),
       status_code: 200
     }}
  end

  defp mock_response_ko do
    {:ok,
     %HTTPoison.Response{
       body: "Not found",
       status_code: 404
     }}
  end
end
