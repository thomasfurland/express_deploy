defmodule AnsibleRelayTest do
  use ExUnit.Case
  doctest AnsibleRelay

  test "greets the world" do
    assert AnsibleRelay.hello() == :world
  end
end
