defmodule Utils do
  @doc """
  Loads the puzzle input from the file in the 'day_XX' root directory.

  ## Examples

      iex> Utilitis.load("day_01.input") |> String.slice(0, 3)
      "-10"

  """
  def load(filename) do
    case File.read((__ENV__.file |> Path.dirname) <> "/../inputs/" <> filename) do
      {:ok, content} -> content
      _ -> raise "Could not find input file. Please run from the exs file location."
    end
  end
end
