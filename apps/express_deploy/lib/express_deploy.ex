defmodule ExpressDeploy do
  @moduledoc """
  Documentation for `ExpressDeploy`.
  """

  require EEx

  @resource_directory ""
  @temp_directory ""

  def run(config, opts \\ [], fnc) do
    resource_directory = config[:resource_directory] || @resource_directory
    temp_directory = config[:temp_directory] || @temp_directory
    
    if Keyword.get(opts, :recreate_temp, true) do
      File.rm_rf(temp_directory)
      File.mkdir(temp_directory)
    end
    
    with {:ok, files} <- File.ls(resource_directory) do
      for file <- files do
        destination = 
          file
          |> String.replace_trailing(".eex", "")
          |> Path.expand(temp_directory)

        file
        |> Path.expand(resource_directory)
        |> EEx.eval_file(assigns: config)
        |> then(&File.write(destination, &1))
      end

      fnc.(temp_directory)
    end
  end
end
