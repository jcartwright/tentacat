defmodule Tentacat.Repositories.LabelsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Tentacat.Repositories.Labels

  doctest Tentacat.Repositories.Labels

  @client Tentacat.Client.new(%{access_token: "yourtokencomeshere"})

  setup_all do
    HTTPoison.start
  end

  test "list/3" do
    use_cassette "repositories/labels#list" do
      assert list("danielfarrell", "elixir", @client) == [%{"url" => "https://api.github.com/repos/danielfarrell/elixir/labels/WIP", "name" => "WIP", "color" => "000000"}]
    end
  end

  test "find/4" do
    use_cassette "repositories/labels#find" do
      %{"name" => name, "color" => color} = find("danielfarrell", "elixir", "WIP", @client)
      assert name == "WIP"
      assert color == "000000"
    end
  end

  test "create/4" do
    use_cassette "repositories/labels#create" do
      {status_code, %{"name" => name, "color" => color}} = create("danielfarrell", "elixir", %{name: "WIP", color: "123456"}, @client)
      assert status_code == 201
      assert name == "WIP"
      assert color == "123456"
    end
  end

  test "update/5" do
    use_cassette "repositories/labels#update" do
      %{"name" => name, "color" => color} = update("danielfarrell", "elixir", "WIP", %{color: "654321"}, @client)
      assert name == "WIP"
      assert color == "654321"
    end
  end

  test "delete/4" do
    use_cassette "repositories/labels#delete" do
      {status_code, _} = delete("danielfarrell", "elixir", "WIP", @client)
      assert status_code == 204
    end
  end
end
