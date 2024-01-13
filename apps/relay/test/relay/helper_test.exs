defmodule Relay.HelperTest do
  use ExUnit.Case, async: true
  
  setup do
    json = Jason.encode!(%{test: "test"})
    json_list = [json, json]

    %{json: json, json_list: json_list}
  end

  describe "parse_output/1" do
    test "parses json element from Relay Output correctly", %{json: json} do
      assert %Relay{out: [%{"test" => "test"}]} = 
        Relay.new()
        |> Map.put(:out, [json])
        |> Relay.Helper.parse_output()
    end
    
    test "parses json elements from Relay Output correctly", %{json_list: json_list} do
      assert %Relay{out: [[%{"test" => "test"}, %{"test" => "test"}]]} = 
        Relay.new()
        |> Map.put(:out, [json_list])
        |> Relay.Helper.parse_output()
    end
  end

  describe "parse_json/1" do
    test "parses json input", %{json: json} do
      assert %{"test" => "test"} = Relay.Helper.parse_json(json)
    end

    test "parses json lines input", %{json_list: json_list} do
      json_lines = Enum.join(json_list, "\n")
      assert [%{"test" => "test"}, %{"test" => "test"}] = Relay.Helper.parse_json(json_lines)
    end
  end
end
