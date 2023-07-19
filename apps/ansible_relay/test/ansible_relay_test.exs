defmodule AnsibleRelayTest do
  use ExUnit.Case, async: true
  
  @path Path.expand("./test/priv/", File.cwd!())
  @moduletag timeout: :infinity

  test "dynamic_inventory/1" do
    Relay.new()
    |> AnsibleRelay.dynamic_inventory([path: @path, file: "gcp.yaml"])
    |> IO.inspect()
  end
end
