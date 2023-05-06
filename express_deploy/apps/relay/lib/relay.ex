defmodule Relay do
  @moduledoc """
  Documentation for `Relay`.
  """
  
  defstruct [in: [], out: [], status: :ok]

  @opts [:binary, :use_stdio, :stderr_to_stdout]

  def new(_opts \\ []) do
    %__MODULE__{}
  end
  
  def cmd(state, cmd, args, opts \\ [], check_fnc \\ &default/1)

  def cmd(%__MODULE__{status: :error} = state, _, _, _, _), do: state
  def cmd(%__MODULE__{} = state, cmd, args, opts, check_fnc) do
    with opts <- get_valid_opts(opts, [{:args, args} | @opts]),
         path when is_binary(path) <- System.find_executable(cmd),
         port when is_port(port) <- Port.open({:spawn_executable, path}, opts)
    do
      receive do
        {^port, {:exit_status, code}} -> update(state, :error, {cmd, args}, "Exit code: #{code}")
        {^port, {:data, data}} -> 
          data
          |> check_fnc.()
          |> then(&update(state, &1, {cmd, args}, data))
      end
    else
      nil -> update(state, :error, {cmd, args}, :enoent)
    end
  end

  defp get_valid_opts(opts, default) do
    Enum.reduce(opts, default, fn 
      _, acc -> acc 
    end)
  end

  defp update(%__MODULE__{in: inp, out: out}, status, new_inp, new_out) do
    %__MODULE__{
      status: status,
      in: [new_inp | inp],
      out: [new_out | out]
    }
  end

  defp default(_), do: :ok
end
