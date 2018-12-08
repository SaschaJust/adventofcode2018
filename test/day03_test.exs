defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "Part1: puzzle" do
    assert Utils.load("day_03.input") |> Day03.part1 == 100595
  end

  test "Part 1: example" do
    assert """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """ |> Day03.part1 == 4
  end

  test "Part 1: own examples" do
    assert """
    #1 @ 5,5: 20x20
    #2 @ 15,15: 30x30
    #3 @ 15,15: 10x10
    #4 @ 44,44: 1x1
    """ |> Day03.part1 == 101
  end

  test "Part 2: example" do 
    assert """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """ |> Day03.part2 == 3
  end

  test "Part2: puzzle" do
    assert Utils.load("day_03.input") |> Day03.part2 == 415
  end
end
