defmodule Mix.Tasks.Express.Deploy do
  @moduledoc """
    A mix task for deploying a phoenix app with Ansible and Terraform on GCP.
  """
  use Mix.Task

  @shortdoc "Installs dependencies for gcp and ansible"
  def run(_) do
    Relay.new()
    |> Relay.cmd("pip", ["install", "ansible"])
    |> Relay.cmd("pip", ["install", "requests", "google_auth"])
    |> IO.inspect()
  end
end
