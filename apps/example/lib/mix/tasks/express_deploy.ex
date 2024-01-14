defmodule Mix.Tasks.Express.Deploy do
  @moduledoc """
    A mix task for deploying a phoenix app with Ansible and Terraform on GCP.
  """
  use Mix.Task

  @path Path.expand("./priv/resources", File.cwd!())

  @shortdoc "Installs dependencies for gcp and ansible"
  def run(_) do
    
  end

  def run_terraform(_) do
    Path.expand("./terraform", @path) |> IO.inspect() 
  end
end
