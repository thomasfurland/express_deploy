defmodule Mix.Tasks.ExpressDeploy.AnsiblePlaybook do
  @moduledoc """
    A mix task for deploying a phoenix app with Ansible and Terraform on GCP.
  """
  use Mix.Task

  @path Application.compile_env(:example, :resource_path)

  def run(_) do
    config = %{
      resource_directory: Path.expand("./ansible", @path),
      temp_directory: Path.expand("./ansible_temp", @path),
      credential_file: Path.expand("./gcp/credentials.json", @path),
      project: "stone-arcade-388210"
    }
    
    res = 
      ExpressDeploy.run(config, fn dir ->
        Relay.new(path: dir, inventory: "gcp.yaml")
        |> AnsibleRelay.dynamic_inventory()
        |> AnsibleRelay.run_playbook(playbook: "main.yaml")
      end)
    
    IO.inspect(res, label: "SUCCESS")
  end
end
