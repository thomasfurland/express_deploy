defmodule Relay do
  @moduledoc """
  Documentation for `Relay`.
  """
  
  defstruct [common_opts: [], in: [], out: [], status: :ok]

  @opts [:binary, :use_stdio, :stderr_to_stdout, :exit_status]

  def new(opts \\ []) do
    %__MODULE__{common_opts: opts}
  end

  def output(%__MODULE__{} = state), do: __MODULE__.Helper.parse_output(state)
  
  def cmd(state, cmd, args, opts \\ [], check_fnc \\ &default/1)

  def cmd(%__MODULE__{status: :error} = state, _, _, _, _), do: state
  def cmd(%__MODULE__{} = state, cmd, args, opts, check_fnc) do
    with opts <- get_valid_opts(opts, [{:args, args} | @opts]),
         path when is_binary(path) <- System.find_executable(cmd),
         port when is_port(port) <- Port.open({:spawn_executable, path}, opts),
         data = collect_responses(port)
    do
      data
      |> check_fnc.()
      |> then(&update(state, %{status: &1, in: {cmd, args}, out: data}))
    else
      nil -> update(state, %{status: :error, in: {cmd, args}, out: :enoent})
    end
  end

  defp collect_responses(port, collected \\ []) do
    receive do
      {^port, {:exit_status, 0}} -> collected
      {^port, {:exit_status, code}} -> ["Exit code: #{code}" | collected]
      {^port, {:data, data}} -> collect_responses(port, [data | collected])
    end
  end

  defp get_valid_opts(opts, default) do
    Enum.reduce(opts, default, fn 
      _, acc -> acc 
    end)
  end

  defp update(%__MODULE__{in: inp, out: out} = state, %{
    status: status,
    in: new_inp,
    out: new_out
  }) do
    %__MODULE__{state |
      status: status,
      in: [new_inp | inp],
      out: [new_out | out]
    }
  end

  defp default(_), do: :ok
end
