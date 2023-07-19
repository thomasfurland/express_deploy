defmodule AnsibleRelay do
  @moduledoc """
  Documentation for `AnsibleRelay`.
  """

  @default_opts [
    path: "/resources/ansible/"
  ]

  def dynamic_inventory(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    args =
      [c_opts, opts]
      |> merge_opts()
      |> process_opts()
      |> opts_to_args()
      |> Kernel.++(["--list"])

    relay
    |> Relay.cmd("ansible-inventory", args)
    |> Relay.output()
  end
  
  defp merge_opts(opts), do: 
    Enum.reduce([@default_opts | opts], &Keyword.merge(&2, &1))

  defp process_opts(opts) do
    Enum.reduce(opts, [], fn 
      {:path, path}, acc -> Keyword.update(acc, :inventory, path, & "#{path}/#{&1}")
      {:file, file}, acc -> Keyword.update(acc, :inventory, file, & "#{&1}/#{file}")
    end)
  end
  
  defp opts_to_args(opts) do
    Enum.reduce(opts, [], fn 
      {:inventory, inventory}, acc -> ["-i", inventory | acc]
    end)
  end
end
