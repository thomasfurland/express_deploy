defmodule Mix.Tasks.ExpressDeploy.TerraformApply do
  @moduledoc """
    A mix task for deploying a phoenix app with Ansible and Terraform on GCP.
  """
  use Mix.Task

  @path Application.compile_env(:example, :resource_path)

  def run(_) do
    config = %{
      resource_directory: Path.expand("./terraform", @path),
      temp_directory: Path.expand("./terraform_temp", @path),
      credential_file: Path.expand("./gcp/credentials.json", @path),
      project: "stone-arcade-388210",
      region: "asia-northeast1",
      zone: "asia-northeast1-a"
    }
    
    res = 
      ExpressDeploy.run(config, fn dir ->
        Relay.new(path: dir)
        |> TerraformRelay.init()
        |> TerraformRelay.fmt()
        |> TerraformRelay.validate()
        |> TerraformRelay.plan()
        |> TerraformRelay.destroy()
      end)
    
    IO.inspect(res, label: "SUCCESS")
  end
end
