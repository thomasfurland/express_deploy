defmodule TerraformRelay do
  @moduledoc """
  Documentation for `TerraformRelay`.
  """
  
  @default_opts [
    path: "/resources/terraform/", 
    output: "-json",
    auto_approve: true,
  ]

  def init(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    ok_msg = "Terraform has been successfully initialized!"
    opts = merge_opts([c_opts, opts])
    args = valid_global_args(opts) ++ ["init"]

    relay
    |> Relay.cmd("terraform", args, [], &string_in_data(&1, ok_msg))
    |> Relay.output()
  end

  def fmt(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    err_msg = "Usage: terraform [global options] fmt [options]"
    opts = merge_opts([c_opts, opts])
    args = valid_global_args(opts) ++ ["fmt"]

    relay
    |> Relay.cmd("terraform", args, [], & not string_in_data(&1, err_msg))
    |> Relay.output()
  end
  
  def validate(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    ok_msg = ~s(\"valid\": true)
    opts = merge_opts([c_opts, opts])

    local = Enum.reduce(opts, [], fn 
      {:output, value}, acc -> [value | acc]
      _, acc -> acc
    end)

    args = valid_global_args(opts) ++ ["validate" | local]

    relay
    |> Relay.cmd("terraform", args, [], &string_in_data(&1, ok_msg))
    |> Relay.output()
  end
  
  def plan(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    err_msg = "For more help on using this command, run"
    opts = merge_opts([c_opts, opts])

    local = Enum.reduce(opts, [], fn 
      {:output, value}, acc -> [value | acc]
      _, acc -> acc
    end)

    args = valid_global_args(opts) ++ ["plan" | local]

    relay
    |> Relay.cmd("terraform", args, [], & not string_in_data(&1, err_msg))
    |> Relay.output()
  end
  
  def show(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    opts = merge_opts([c_opts, opts])

    local = Enum.reduce(opts, [], fn 
      {:output, value}, acc -> [value | acc]
      _, acc -> acc
    end)

    args = valid_global_args(opts) ++ ["show" | local]

    relay
    |> Relay.cmd("terraform", args)
    |> Relay.output()
  end
  
  def apply(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    err_msg = "For more help on using this command, run"
    opts = merge_opts([c_opts, opts])

    local = Enum.reduce(opts, [], fn 
      {:output, value}, acc -> [value | acc]
      {:auto_approve, true}, acc -> ["-auto-approve" | acc]
      _, acc -> acc
    end)

    args = valid_global_args(opts) ++ ["apply" | local]

    relay
    |> Relay.cmd("terraform", args, [], & not string_in_data(&1, err_msg))
    |> Relay.output()
  end
  
  def destroy(%Relay{common_opts: c_opts} = relay \\ Relay.new(), opts \\ []) do
    err_msg = "For more help on using this command, run"
    opts = merge_opts([c_opts, opts])

    local = Enum.reduce(opts, [], fn 
      {:output, value}, acc -> [value | acc]
      {:auto_approve, true}, acc -> ["-auto-approve" | acc]
      _, acc -> acc
    end)

    args = valid_global_args(opts) ++ ["destroy" | local]

    relay
    |> Relay.cmd("terraform", args, [], & not string_in_data(&1, err_msg))
    |> Relay.output()
  end

  defp merge_opts(opts), do: 
    Enum.reduce([@default_opts | opts], &Keyword.merge(&2, &1))

  defp valid_global_args(opts) do
    Enum.reduce(opts, [], fn 
      {:path, value}, acc -> [ "-chdir=#{value}" | acc]
      _, acc -> acc
    end)
  end

  defp string_in_data(data, regex) when is_binary(data), do: data =~ regex
  defp string_in_data(data, regex) when is_list(data), do:
    Enum.any?(data, &string_in_data(&1, regex))
end
