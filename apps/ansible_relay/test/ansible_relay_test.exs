defmodule AnsibleRelayTest do
  use ExUnit.Case, async: true
  
  @path Path.expand("./test/priv/", File.cwd!())
  @moduletag timeout: :infinity

  test "relay chaining works" do
    Relay.new(path: @path, inventory: "gcp.yaml")
    |> AnsibleRelay.dynamic_inventory()
    |> AnsibleRelay.run_playbook(playbook: "main.yaml")
    |> IO.inspect(label: "ALL")
  end

  test "dynamic_inventory/1" do
    Relay.new(path: @path, inventory: "gcp.yaml")
    |> AnsibleRelay.dynamic_inventory()
    |> IO.inspect(label: "DYNAMIC INVENTORY")
  end
  
  test "run_playbook/1" do
    Relay.new(path: @path, inventory: "gcp.yaml")
    |> AnsibleRelay.run_playbook(playbook: "main.yaml")
    |> IO.inspect(label: "RUN PLAYBOOK")
  end
end
