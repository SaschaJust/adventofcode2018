defmodule Day06 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 6](https://adventofcode.com/2018/day/6). 

  ## Day 6: Chronal Coordinates

  The device on your wrist beeps several times, and once again you feel 
  like you're falling.

  "Situation critical," the device announces. "Destination indeterminate. 
  Chronal interference detected. Please specify new target coordinates."

  The device then produces a list of coordinates (your puzzle input). Are 
  they places it thinks are safe or dangerous? It recommends you check 
  manual page 729. The Elves did not give you a manual.

  _If they're dangerous_, maybe you can minimize the danger by finding the 
  coordinate that gives the largest distance from the other points.

  Using only the [Manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry), determine the _area_ around each 
  coordinate by counting the number of [integer](https://en.wikipedia.org/wiki/Integer) X,Y locations that are 
  _closest_ to that coordinate (and aren't _tied in distance_ to any other 
  coordinate).

  Your goal is to find the size of the _largest area_ that isn't infinite. 
  For example, consider the following list of coordinates:

  ```
  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  ```

  If we name these coordinates `A` through `F`, we can draw them on a grid, 
  putting `0,0` at the top left:

  ```
  ..........
  .A........
  ..........
  ........C.
  ...D......
  .....E....
  .B........
  ..........
  ..........
  ........F.
  ```
  """

  def preprocess(input) do
    input 
    |> String.trim
    |> String.split("\n")
    |> Enum.map(
      fn line -> String.split(line, ", ") |> Enum.map(&String.to_integer/1) |> List.to_tuple end
    )
    |> Enum.sort
  end

  @doc """
  Solves part 1 of the puzzle.

  ## Description

  This view is partial - the actual grid extends infinitely in all 
  directions. Using the Manhattan distance, each location's closest 
  coordinate can be determined, shown here in lowercase:

  ```
  aaaaa.cccc
  aAaaa.cccc
  aaaddecccc
  aadddeccCc
  ..dDdeeccc
  bb.deEeecc
  bBb.eeee..
  bbb.eeefff
  bbb.eeffff
  bbb.ffffFf
  ```

  Locations shown as `.` are equally far from two or more coordinates, and so
  they don't count as being closest to any.

  In this example, the areas of coordinates A, B, C, and F are infinite -
  while not shown here, their areas extend forever outside the visible 
  grid. However, the areas of coordinates D and E are finite: D is closest 
  to 9 locations, and E is closest to 17 (both including the coordinate's 
  location itself). Therefore, in this example, the size of the largest 
  area is _17_.

  _What is the size of the largest area_ that isn't infinite?

  ## Usage

  Returns `Integer`.
  """
  def part1(input) do
    data = input |> preprocess

    {{x_min, x_max}, {y_min, y_max}} = data |> bounds
    
    indexed = data |> Enum.with_index
    hull = data |> quickhull
    hull_indexes = indexed 
      |> Enum.filter(fn {point, _index} -> Enum.member?(hull, point) end) 
      |> Enum.map(fn {_point, index} -> index end) 
      |> MapSet.new

    map(
      indexed, 
      (for x <- x_min..x_max, y <- y_min..y_max, do: {x, y}), 
      %{}
    ) 
    |> Enum.max_by(fn {id, size} -> Enum.member?(hull_indexes, id) && 0 || size end)
    |> Tuple.to_list
    |> List.last
  end

  @doc """
  Solves part 2 of the puzzle.

  ## Description

  On the other hand, _if the coordinates are safe_, maybe the best you can do 
  is try to find a _region_ near as many coordinates as possible.

  For example, suppose you want the sum of the [Manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry) to all of 
  the coordinates to be _less than 32_. For each location, add up the 
  distances to all of the given coordinates; if the total of those 
  distances is less than 32, that location is within the desired region. 
  Using the same coordinates as above, the resulting region looks like 
  this:

  ```
  ..........
  .A........
  ..........
  ...###..C.
  ..#D###...
  ..###E#...
  .B.###....
  ..........
  ..........
  ........F.
  ```

  In particular, consider the highlighted location `4,3` located at the top 
  middle of the region. Its calculation is as follows, where abs() is the 
  [absolute value](https://en.wikipedia.org/wiki/Absolute_value) function:

  * Distance to coordinate A: `abs(4-1) + abs(3-1) =  5`
  * Distance to coordinate B: `abs(4-1) + abs(3-6) =  6`
  * Distance to coordinate C: `abs(4-8) + abs(3-3) =  4`
  * Distance to coordinate D: `abs(4-3) + abs(3-4) =  2`
  * Distance to coordinate E: `abs(4-5) + abs(3-5) =  3`
  * Distance to coordinate F: `abs(4-8) + abs(3-9) = 10`
  * Total distance: `5 + 6 + 4 + 2 + 3 + 10 = 30`
  
  Because the total distance to all coordinates (`30`) is less than 32, the 
  location is _within_ the region.

  This region, which also includes coordinates D and E, has a total size of 
  _16_.

  Your actual region will need to be much larger than this example, though, 
  instead including all locations with a total distance of less than _10000_.

  _What is the size of the region containing all locations which have a 
  total distance to all given coordinates of less than 10000?_

  ## Usage

  Returns `Integer`.
  """
  def part2(input, max_sum) do
    data = input |> preprocess
    {{x_min, x_max}, {y_min, y_max}} = data |> bounds
    
    map2(
      data, 
      (for x <- x_min..x_max, y <- y_min..y_max, do: {x, y}), 
      0, 
      max_sum
    ) 
  end

  def map2(_list, [], results, _) do
    results
  end

  def map2(list, [c | tail], results, max_sum) do
    accumulated_distance = list |> Enum.reduce(0, &(&2 + manhattan(c, &1)))
    map2(list, tail, results+((accumulated_distance < max_sum) && 1 || 0), max_sum)
  end


  defp manhattan({x1, y1}, {x2, y2}), do: Kernel.abs(y2-y1)+Kernel.abs(x2-x1)

  def map(_, [], results) do
    results
  end

  def map(list, [c | tail], results) do
    {_min, points} = list |> Enum.reduce(
      {:infinity, []}, 
      fn {r, index}, {min, l} -> 
        d = manhattan(c, r)
        cond do 
          d < min -> {d, [index]}
          d == min -> {d, l ++ [index]}
          true -> {min, l}
        end
      end)
    if length(points) == 1 do
      map(list, tail, Map.update(results, points |> List.first, 1, &(&1+1)))
    else
      map(list, tail, results)
    end
  end

  def quickhull(points) do
    {a, b} = points |> Enum.min_max

    s1 = points |> Enum.filter(&right?(a, b, &1))
    s2 = points |> Enum.filter(&right?(b, a, &1))

    [a] ++ 
    findhull(
      s1,
      a,
      b
    ) ++ [b] ++ findhull(
      s2,
      b,
      a
    )
  end

  def distance({x1, y1}, {x2, y2}, {x3, y3}) do
    case x2 - x1 do
      0 -> (y2-y1)>0 && (x3 - x2) ||  (x2 - x3) 
      dx -> 
        m = (y2-y1)/dx
        ref_y = y1 + (x3-x1)*m
        if x1 < x2, do: ref_y - y3, else: y3 - ref_y
    end
  end

  def right?(a, b, c) do
    distance(a, b, c) > 0
  end

  def findhull([], _, _) do
    []
  end

  def findhull(sk, p, q) do
    c = sk |> Enum.max_by(&Kernel.abs(distance(p, q, &1)))
    s1 = sk |> Enum.filter(&right?(p, c, &1))
    s2 = sk |> Enum.filter(&right?(c, q, &1))
    findhull(s1, p, c) ++ [c] ++ findhull(s2, c, q)
  end

  def bounds(list, x \\ {:infinity, 0}, y \\ {:infinity, 0})

  def bounds([], x_bounds, y_bounds) do
    {x_bounds, y_bounds}
  end

  def bounds([{x, y} | tail], {x_min, x_max}, {y_min, y_max}) do
    bounds(tail, {Kernel.min(x_min, x), Kernel.max(x_max, x)}, {Kernel.min(y_min, y), Kernel.max(y_max, y)})
  end
end
