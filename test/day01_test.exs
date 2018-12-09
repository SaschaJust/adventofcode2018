defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @input Utils.load("day_01.input")

  test "Parses the puzzle input" do
    data = Day01.parse(@input)
    assert length(data) > 0
    assert data |> Enum.at(0) == -10
  end

  test "Part 1: examples" do
    assert "+1\n+1\n+1" |> Day01.part1 == 3
    assert "+1\n+1\n-2" |> Day01.part1 == 0
    assert "-1\n-2\n-3" |> Day01.part1 == -6
  end

  test "Part 1: puzzle" do
    assert @input |> Day01.part1 == 529
  end

  test "Part 2: examples" do
    assert "1\n-1" |> Day01.part2 == 0
    assert "+3\n+3\n+4\n-2\n-4" |> Day01.part2 == 10
    assert "-6\n+3\n+8\n+5\n-6" |> Day01.part2 == 5
    assert "+7\n+7\n-2\n-7\n-4" |> Day01.part2 == 14
  end

  test "Part 2: puzzle" do
    assert @input |> Day01.part2 == 464
  end

end
