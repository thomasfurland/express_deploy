defmodule TerraformRelayTest do
  use ExUnit.Case, async: true
  
  @path Path.expand("./test/priv/", File.cwd!())
  
  @moduletag timeout: :infinity

  describe "relay chaining works" do
    test "success: returns all inputs and outputs from chain" do
      
      Relay.new(path: @path)
      |> TerraformRelay.init()
      |> TerraformRelay.fmt()
      |> TerraformRelay.validate()
      |> IO.inspect(label: "ALL")
    end
  end

  describe "init/2" do

    test "success: initializes terraform with init file" do
      TerraformRelay.init(Relay.new(), path: @path)
      |> IO.inspect(label: "INIT")
    end
  end
  
  describe "fmt/2" do

    test "success: formats terraform config" do
      TerraformRelay.fmt(Relay.new(), path: @path)
      |> IO.inspect(label: "FMT")
    end
  end
  
  describe "validate/2" do
    test "success: formats terraform config" do
      TerraformRelay.validate(Relay.new(), path: @path)
      |> IO.inspect(label: "VALIDATE")
    end
  end
  
  describe "plan/2" do
    test "success: generates plan from terraform config" do
      TerraformRelay.plan(Relay.new(), path: @path)
      |> IO.inspect(label: "PLAN")
    end
  end
  
  describe "show/2" do
    test "success: shows existing terraform infrastructure" do
      TerraformRelay.show(Relay.new(), path: @path)
      |> IO.inspect(label: "SHOW")
    end
  end
  
  describe "destroy/2" do
    test "success: tears down existing terraform infrastructure" do
      TerraformRelay.destroy(Relay.new(), path: @path)
      |> IO.inspect(label: "DESTROY")
    end
  end
  
  describe "apply/2" do
    test "success: creates terraform infrastructure from config" do
      TerraformRelay.apply(Relay.new(), path: @path)
      |> IO.inspect(label: "APPLY")
    end
  end
end
