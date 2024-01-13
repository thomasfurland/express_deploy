defmodule ExpressDeployTest do
  use ExUnit.Case
  
  @path Path.expand("./test/priv/", File.cwd!())

  describe "run/2" do
    test "generates correct file in correct folder" do
      config = 
        %{
          foo: "bar",
          fizz: "buzz",
          credential_file: "credential_file.json",
          resource_directory: "#{@path}/resource_dir",
          temp_directory: "#{@path}/temp_dir"
        }
      
      assert {:ok, contents} = ExpressDeploy.run(config, fn dir -> File.read("#{dir}/test_file.txt") end)

      assert contents =~ "fizz: buzz"
      assert contents =~ "foo: bar"
      assert contents =~ "credential_file: #{@path}/resource_dir/credential_file.json"

      IO.inspect(contents)
    end
  end
end
