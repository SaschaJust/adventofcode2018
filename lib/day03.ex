defmodule Day03 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 2](https://adventofcode.com/2018/day/2). 

  ## Day 3: No Matter How You Slice It

  The Elves managed to locate the chimney-squeeze prototype fabric for 
  Santa's suit (thanks to someone who helpfully wrote its box IDs on the 
  wall of the warehouse in the middle of the night). Unfortunately, 
  anomalies are still affecting them - nobody can even agree on how to cut 
  the fabric.

  The whole piece of fabric they're working on is a very large square - at 
  least 1000 inches on each side.

  Each Elf has made a _claim_ about which area of fabric would be ideal for 
  Santa's suit. All claims have an ID and consist of a single rectangle 
  with edges parallel to the edges of the fabric. Each claim's rectangle is 
  defined as follows:

  * The number of inches between the left edge of the fabric and the left 
    edge of the rectangle.
  * The number of inches between the top edge of the fabric and the top 
    edge of the rectangle.
  * The width of the rectangle in inches.
  * The height of the rectangle in inches.

  A claim like `#123 @ 3,2: 5x4` means that claim ID 123 specifies a 
  rectangle `3` inches from the left edge, `2` inches from the top edge, `5` 
  inches wide, and 4 inches tall. Visually, it claims the square inches of 
  fabric represented by `#` (and ignores the square inches of fabric 
  represented by `.`) in the diagram below:

  ```
  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........
  ```
  """

  use Bitwise
  
  @doc """
  Solves part 1 of the puzzle.

  ## Description

  The problem is that many of the claims _overlap_, causing two or more
  claims to cover part of the same areas. For example, consider the 
  following claims:

  ```
  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  ```

  Visually, these claim the following areas:

  ```
  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........
  ```

  The four square inches marked with `X` are claimed by _both `1` and `2`_. (Claim 
  `3`, while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have 
  enough fabric. _How many square inches of fabric are within two or more 
  claims_?
  """
  def part1(input) do
    input
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        &Regex.named_captures(~r/^#(?<id>\d+)\s@\s(?<xoffset>\d+),(?<yoffset>\d+):\s(?<xdim>\d+)x(?<ydim>\d+)$/, &1)
          |> Enum.map(fn {_k, v} -> v |> String.to_integer end)
          |> (fn [_id, xdim, xoffset, ydim, yoffset] -> 
            (if yoffset > 0, do: (for _ <- 1..yoffset, do: 0), else: [])
            ++ 
            (for _ <- 1..ydim, do: ((:math.pow(2, xdim)-1 |> Kernel.trunc) <<< xoffset))
            ++
            (for _ <- yoffset+ydim..1000, do: 0)
             end).()
        )
      |> Enum.reduce(Enum.zip((for _ <- 1..1000, do: 0), (for _ <- 1..1000, do: 0)), 
                    fn x, acc -> Enum.zip(x, acc) |> Enum.map(
                        fn {mask, {duplicate, all}} -> {(mask &&& all) ||| duplicate, all ||| mask} end) 
                    end)
      |> Enum.map(fn {duplicate, _all} -> for(<<bit::1 <- :binary.encode_unsigned(duplicate)>>, do: bit) |> Enum.sum end)
      |> Enum.sum
  end

  def part12(input) do
    input
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        &Regex.named_captures(~r/^#(?<id>\d+)\s@\s(?<xoffset>\d+),(?<yoffset>\d+):\s(?<xdim>\d+)x(?<ydim>\d+)$/, &1)
          |> Enum.map(fn {_k, v} -> v |> String.to_integer end)
          |> (fn [_id, xdim, xoffset, ydim, yoffset] -> 
            (for x <- xoffset..xdim+xoffset-1, y <- yoffset..ydim+yoffset-1, do: {x, y}) |> MapSet.new end).()
        )
      |> Enum.reduce({MapSet.new(), MapSet.new()}, 
        fn x, {dup, all} -> {MapSet.union(MapSet.intersection(x, all), dup), MapSet.union(all, x)} end)
      |> (fn {dup, _all} -> MapSet.size(dup) end).()
  end

  @doc """
  Amidst the chaos, you notice that exactly one claim doesn't overlap by 
  even a single square inch of fabric with any other claim. If you can 
  somehow draw attention to it, maybe the Elves will be able to make 
  Santa's suit after all!

  For example, in the claims above, only claim `3` is intact after all claims 
  are made.

  _What is the ID of the only claim that doesn't overlap?_
  """
  def part2(input) do
    input
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        &Regex.named_captures(~r/^#(?<id>\d+)\s@\s(?<xoffset>\d+),(?<yoffset>\d+):\s(?<xdim>\d+)x(?<ydim>\d+)$/, &1)
          |> Enum.map(fn {_k, v} -> v |> String.to_integer end)
          |> (fn [id, xdim, xoffset, ydim, yoffset] -> 
            (for x <- xoffset..xdim+xoffset-1, y <- yoffset..ydim+yoffset-1, do: {{x, y}, [id]}) |> Map.new end).()
        )
      |> Enum.reduce(Map.new(), fn x, acc -> Map.merge(x, acc, fn _k, v1, v2 -> v1 ++ v2 end) end)
      |> Enum.reduce({MapSet.new, MapSet.new}, 
          fn {_p, ids}, {candidates, blacklist} -> {MapSet.union(candidates, ids |> MapSet.new), (if length(ids) > 1, do: MapSet.union(blacklist, ids |> MapSet.new), else: blacklist)}
        end)
      |> (fn {candidates, blacklist} -> MapSet.difference(candidates, blacklist) end).()
      |> Enum.at(0)
  end
end
