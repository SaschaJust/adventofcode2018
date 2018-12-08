defmodule Day03Bench do
  use Benchfella

  bench "Part 1: Integer masks" do
    Utils.load("day_03.input") |> Day03.part1
  end

  bench "Part 1: MapSets" do
    Utils.load("day_03.input") |> Day03.part12
  end

  bench "Part 2: MapSets" do
    Utils.load("day_03.input") |> Day03.part2
  end

end

