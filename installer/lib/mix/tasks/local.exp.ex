defmodule Mix.Tasks.Local.Exp do
  use Mix.Task

  @shortdoc "Updates the Phoenix project generator locally"

  @moduledoc """
  Updates the Phoenix project generator locally.

      $ mix local.phx

  Accepts the same command line options as `archive.install hex phx_new`.
  """

  @impl true
  def run(args) do
    Mix.Task.run("archive.install", ["hex", "exp_new" | args])
  end
end