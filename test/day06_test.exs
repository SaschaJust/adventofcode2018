defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  test "Part 1: example" do
    assert """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """ |> Day06.part1 == 17
  end

  test "Part 2: example" do
    assert """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """ |> Day06.part2(32) == 16
  end

  test "Distance" do
    assert Day06.distance({0,0}, {5,5}, {1,1}) == 0
    assert Day06.distance({0,0}, {5,5}, {1,2}) < 0
    assert Day06.distance({5,5}, {0,0}, {1,2}) > 0
    assert Day06.distance({5,5}, {0,0}, {1,0}) < 0
    assert Day06.distance({0,0}, {0,5}, {1,0}) > 0
    assert Day06.distance({0,5}, {0,0}, {1,0}) < 0
  end

  test "Part 1: puzzle" do
    assert Utils.load("day_06.input") |> Day06.part1 == 2917
  end

  test "Part 2: puzzle" do
    assert Utils.load("day_06.input") |> Day06.part2(10_000) == 44202
  end
end
