defmodule TerraformRelayTest do
  use ExUnit.Case
  doctest TerraformRelay

  test "greets the world" do
    assert TerraformRelay.hello() == :world
  end
end
