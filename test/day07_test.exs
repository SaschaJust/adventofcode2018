defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  test "Part 1: example" do
    assert """
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """ |> Day07.part1 == "CABDFE"
  end

  test "Part 1: puzzle" do
    assert Utils.load("day_07.input") |> Day07.part1 == "ACBDESULXKYZIMNTFGWJVPOHRQ"
  end

  test "Part 2: example" do
    assert """
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """ |> Day07.part2(2, 0) == 15
  end

  test "Part 2: puzzle" do
    assert Utils.load("day_07.input") |> Day07.part2 == 980
  end
end
