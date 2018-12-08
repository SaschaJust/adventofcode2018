defmodule Day05 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 5](https://adventofcode.com/2018/day/5). 

  ## Day 5: Alchemical Reduction

  You've managed to sneak in to the prototype suit manufacturing lab. The 
  Elves are making decent progress, but are still struggling with the 
  suit's size reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved 
  their problem eventually, you can do better. You scan the chemical 
  composition of the suit's material and discover that it is formed by 
  extremely long [polymers](https://en.wikipedia.org/wiki/Polymer) (one of which is available as your puzzle input).

  The polymer is formed by smaller _units_ which, when triggered, react with 
  each other such that two adjacent units of the same type and opposite 
  polarity are destroyed. Units' types are represented by letters; units'
   polarity is represented by capitalization. For instance, `r` and `R` are 
   units with the same type but opposite polarity, whereas `r` and `s` are 
   entirely different types and do not react.

  For example:

  * In `aA`, `a` and `A` react, leaving nothing behind.
  * In `abBA`, `bB` destroys itself, leaving `aA`. As above, this then destroys 
    itself, leaving nothing.
  * In `abAB`, no two adjacent units are of the same type, and so nothing 
    happens.
  * In `aabAAB`, even though `aa` and `AA` are of the same type, their 
    polarities match, and so nothing happens.
  """
  @compile if Mix.env == :test, do: :export_all

  def load do
    case File.read((__ENV__.file |> Path.dirname) <> "/../../day_05.input") do
      {:ok, content} -> content
      _ -> raise "Could not find input file. Please run from the exs file location."
    end
  end

  defp react?(a, b) do
    cond do
      String.upcase(a) == a -> String.downcase(a) == b
      true -> String.upcase(a) == b
    end
  end

  def part1(input) do
    list = for <<c::8 <- input |> String.trim>>, into: [], do: <<c>>
    list |> t
  end

  def part2(input) do
    list = for <<c::8 <- input |> String.trim>>, into: [], do: <<c>>
    (for i <- ?a..?z, into: [], do: i)
    |> Enum.map(fn c -> list |> Enum.filter(&(&1 != <<c>> && &1 != <<c-?a+?A>>)) |> t end)
    |> Enum.min
  end

  def t(remainder, processed \\ [])

  def t([head | tail], []) do
    t(tail, [head])
  end

  def t([], processed) do
    length(processed)
  end

  def t([b | restb], [a | resta]) do
    if react?(a, b), do: t(restb, resta), else: t(restb, [b, a] ++ resta)
  end
end
