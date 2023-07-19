defmodule Relay.Helper do
  def parse_output(%Relay{out: [output | rest]} = relay) when is_list(output) do
    output
    |> Enum.flat_map(&parse_json/1)
    |> Enum.reject(& &1 === "")
    |> Enum.reverse()
    |> then(& %Relay{relay | out: [&1 | rest]})
  end

  def parse_output(%Relay{out: [output | rest]} = relay) do
    with {:error, _} <- Jason.decode(output),
         {:ok, json} <- decode_json_lines(output)
    do
      %Relay{relay | out: [json | rest]}
    else
      {:ok, json} -> %Relay{relay | out: [json | rest]}
      {:error, _} -> relay
    end
  end

  def parse_json(value) do
    with {:error, _} <- Jason.decode(value),
         {:ok, json} <- decode_json_lines(value)
    do
      json
    else
      {:ok, json} -> json
      {:error, _} -> String.split(value, "\n")
    end
  end
  
  def decode_json_lines(string) do
    string
    |> String.split("\n")
    |> Enum.map(&Jason.decode/1)
    |> Enum.filter(& elem(&1, 0) === :ok)
    |> case do
      [] -> {:error, string}
      json -> 
        json
        |> Enum.map(fn {_, res} -> res end)
        |> then(& {:ok, &1})
    end
  end
end
