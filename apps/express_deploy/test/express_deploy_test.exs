defmodule ExpressDeployTest do
  use ExUnit.Case
  doctest ExpressDeploy

  test "greets the world" do
    assert ExpressDeploy.hello() == :world
  end
end
