defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  test "Part 1: example" do
    assert """
    2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
    """ |> Day08.part1 == 138
  end

  test "Part 1: puzzle" do
    assert Utils.load("day_08.input") |> Day08.part1 == 43351
  end

  test "Part 2: example" do
    assert """
    2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
    """ |> Day08.part2 == 66
  end

  test "Part 2: puzzle" do
    assert Utils.load("day_08.input") |> Day08.part2 == 21502
  end
end
