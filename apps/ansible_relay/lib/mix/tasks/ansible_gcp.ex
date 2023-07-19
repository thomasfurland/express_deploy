defmodule Mix.Tasks.Ansible.Gcp do
  @moduledoc """
    A mix task for installing dependencies for specific ansible use cases.
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
