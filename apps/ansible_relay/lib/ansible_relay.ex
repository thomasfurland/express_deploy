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
  
  def run_playbook(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    args =
      [c_opts, opts]
      |> merge_opts()
      |> process_opts()
      |> opts_to_args()

    relay
    |> Relay.cmd("ansible-playbook", args)
    |> Relay.output()
  end
  
  defp merge_opts(opts), do: 
    Enum.reduce([@default_opts | opts], &Keyword.merge(&2, &1))

  defp process_opts(opts) do
    Enum.reduce(opts, [], fn 
      {:path, path}, acc -> 
        acc
        |> Keyword.update(:inventory, path, & "#{path}/#{&1}")
        |> Keyword.update(:playbook, path, & "#{path}/#{&1}")
      {:inventory, file}, acc -> Keyword.update(acc, :inventory, file, & "#{&1}/#{file}")
      {:playbook, file}, acc -> Keyword.update(acc, :playbook, file, & "#{&1}/#{file}")
      {:syntax_check, bool}, acc -> Keyword.put(acc, :syntax_check, bool)
    end)
  end
  
  defp opts_to_args(opts) do
    Enum.reduce(opts, [], fn 
      {:inventory, inventory}, acc -> ["-i", inventory | acc]
      {:playbook, playbook}, acc -> [playbook | acc]
      {:syntax_check, true}, acc -> ["--syntax-check" | acc]
      {:syntax_check, _}, acc -> acc
    end)
  end
end
