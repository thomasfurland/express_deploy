defmodule RelayTest do
  use ExUnit.Case, async: true

  describe "new/1" do
    test "creates new relay with passed in opts" do
      assert %Relay{common_opts: [test: "test"]} = Relay.new(test: "test")
    end
  end

  describe "output/1" do
    test "parses output of relay with json output" do
      json = Jason.encode!(%{test: "test"})

      assert %Relay{out: [%{"test" => "test"}]} =
        Relay.new()
        |> Map.put(:out, [json])
        |> Relay.Helper.parse_output()
    end
  end

  describe "cmd/5" do
    test "runs command and stores results in relay" do
      assert %Relay{
        common_opts: [],
        in: [{"pwd", []}],
        out: [["/Users/tommy/Elixir/express_deploy/apps/relay\n"]],
        status: :ok
      } = Relay.cmd(Relay.new(), "pwd", [])
    end
  end
end
