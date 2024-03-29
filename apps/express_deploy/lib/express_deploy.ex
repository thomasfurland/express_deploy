defmodule ExpressDeploy do
  @moduledoc """
  Documentation for `ExpressDeploy`.
  """

  require EEx

  @resource_directory ""
  @temp_directory ""

  def run(config, fnc) do
    params = process_config(config)
    resource_directory = params[:resource_directory] || @resource_directory
    temp_directory = params[:temp_directory] || @temp_directory

    File.rm_rf(temp_directory)
    File.mkdir(temp_directory)
    
    with {:ok, files} <- File.ls(resource_directory) do
      for file <- files do
        destination = 
          file
          |> String.replace_trailing(".eex", "")
          |> Path.expand(temp_directory)

        file
        |> Path.expand(resource_directory)
        |> EEx.eval_file(assigns: params)
        |> then(&File.write(destination, &1))
      end

      fnc.(temp_directory)
    end
  end

  defp process_config(config) do
    Enum.reduce(config, [], fn 
      {:credential_file, file}, acc -> Keyword.update(acc, :credential_file, file, & "#{&1}/#{file}")
      {:resource_directory, directory}, acc -> 
        acc
        |> Keyword.put(:resource_directory, directory)
        |> Keyword.update(:credential_file, directory, & "#{directory}/#{&1}")
      {key, value}, acc -> Keyword.put(acc, key, value)
    end)
  end
end
