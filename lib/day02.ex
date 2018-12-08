defmodule Day02 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 2](https://adventofcode.com/2018/day/2). 

  ## Day 2: Inventory Management System 

  You stop falling through time, catch your breath, and check the screen on
  the device. "Destination reached. Current Year: 1518. Current Location:
  North Pole Utility Closet 83N10." You made it! Now, to find those anomalies.

  Outside the utility closet, you hear footsteps and a voice. "...I'm not 
  sure either. But now that so many people have chimneys, maybe he could 
  sneak in that way?" Another voice responds, "Actually, we've been working 
  on a new kind of suit that would let him fit through tight spaces like 
  that. But, I heard that a few days ago, they lost the prototype fabric, 
  the design plans, everything! Nobody on the team can even seem to 
  remember important details of the project!"

  "Wouldn't they have had enough fabric to fill several boxes in the 
  warehouse? They'd be stored together, so the box IDs should be similar. 
  Too bad it would take forever to search the warehouse for two similar box 
  IDs..." They walk too far away to hear any more.
  """

  @doc """
  Loads the puzzle input from the file in the 'day_XX' root directory.

  ## Examples

      iex> Utils.load("day_02.input") |> String.slice(0, 4)
      "ymdr"

  """
  def load do
    case File.read((__ENV__.file |> Path.dirname) <> "/../../day_02.input") do
      {:ok, content} -> content
      _ -> raise "Could not find input file. Please run from the exs file location."
    end
  end

  @doc """
  Parses the line-based input into a list of integers.

  ## Examples

      iex> Day02.preprocess("\\nymdrcyapvwfloiuktanxzjsieb\\nymdrwhgznwfloiuktanxzjsqeb")
      ["ymdrcyapvwfloiuktanxzjsieb", "ymdrwhgznwfloiuktanxzjsqeb"]

  """
  def preprocess(input) do
    input
      |> String.trim
      |> String.split("\n")
      |> Enum.map(&String.trim/1) 
  end

  @doc """
  Solves part 1 of the puzzle.

  ## Description 

  Late at night, you sneak to the warehouse - who knows what kinds of 
  paradoxes you could cause if you were discovered - and use your fancy 
  wrist device to quickly scan every box and produce a list of the likely 
  candidates (your puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes 
  again, counting the number that have an ID containing exactly two of any 
  letter and then separately counting those with exactly three of any 
  letter. You can multiply those two counts together to get a rudimentary 
  [checksum](https://en.wikipedia.org/wiki/Checksum) and compare it to what your device predicts.

  For example, if you see the following box IDs:

  * `abcdef` contains no letters that appear exactly two or three times.
  * `bababc` contains two `a` and three `b`, so it counts for both.
  * `abbcde` contains two `b`, but no letter appears exactly three times.
  * `abcccd` contains three `c`, but no letter appears exactly two times.
  * `aabcdd` contains two `a` and two `d`, but it only counts once.
  * `abcdee` contains two `e`.
  * `ababab` contains three `a` and three `b`, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly 
  twice, and three of them contain a letter which appears exactly three 
  times. Multiplying these together produces a checksum of `4 * 3 = 12`.
  """
  def part1(input) do
    input
      |> preprocess 
      |> Enum.map(&Day02.occurance/1)
      |> Enum.reduce({0, 0}, fn {two, three}, {a, b} -> {a + (two && 1 || 0), b + (three && 1 || 0)} end)
  end

  @doc """
  Returns a tuple with boolean values denoting whether the given string
  contains a character exactly two or three times. 

  ## Example

      iex> Day02.occurance("aaccc")
      {true, true}

      iex> Day02.occurance("abcde")
      {false, false}
  """
  def occurance(string, map \\ Map.new())

  def occurance(<<c::utf8,rest::bitstring>>, map) do
    occurance(rest, Map.put(map, c, Map.get(map, c, 0) + 1))
  end

  def occurance(<<>>, map) do
    map |> Enum.reduce({false, false}, fn {_, v}, {double, triple} -> {double or v == 2, triple or v == 3} end)
  end

  @doc """
  Checks whether two strings have an edit distance of 1 or less.

  ## Example

      iex> Day02.dist1?("abc", "abz", 0)
      true
      
      iex> Day02.dist1?("abc", "acz", 0)
      false
  """
  def dist1?(<<first::utf8,remainder::bitstring>>, <<first2::utf8,remainder2::bitstring>>, cost) do
    if cost <= 1 do
      dist1?(remainder, remainder2, cost + ((first == first2) && 0 || 1))
    else
      false
    end
  end

  def dist1?(<<>>, <<>>, cost) do
    cost <= 1
  end

  @doc """
  Searches for the element in the list which as at most 1
  edit distance from the given element.

  ## Examples

      iex> Day02.dist1?(["abc", "acz"], "atz")
      "acz"
  """
  def dist1?([ head | tail ], element) do
    if dist1?(head, element, 0) do
      head
    else
      dist1?(tail, element)
    end
  end

  def dist1?([], _element), do: nil

  defp intersect(string1, string2) do
    Enum.zip(string1 |> String.graphemes, string2 |> String.graphemes)
      |> Enum.map(fn {x, y} -> x == y && x || nil end)
      |> Enum.join
  end

  @doc """
  Solves part 2 of the puzzle.
  
  ## Description

  Confident that your list of box IDs is complete, you're ready to find the 
  boxes full of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same 
  position in both strings. For example, given the following box IDs:

  ```
  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz
  ```

  The IDs `abcde` and `axcye` are close, but they differ by two characters (the 
  second and fourth). However, the IDs `fghij` and `fguij` differ by exactly 
  one character, the third (`h` and `u`). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example 
  above, this is found by removing the differing character from either ID, 
  producing `fgij`.)
  """
  def part2([head | tail]) do
    temp = Day02.dist1?(tail, head)
    if temp != nil do
      intersect(temp, head)
    else
      part2(tail)
    end
  end

  def part2([]), do: nil

  def part2(input) do
    input
      |> preprocess
      |> part2
  end
end
