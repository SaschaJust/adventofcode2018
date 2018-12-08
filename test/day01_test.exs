defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @input Utils.load("day_01.input")

  test "Parses the puzzle input" do
    data = Day01.parse(@input)
    assert length(data) > 0
    assert data |> Enum.at(0) == -10
  end

  test "Part 1" do
    assert @input |> Day01.part1 == 529
  end

  test "Part 2, 1" do
    assert [1, -1] |> (&Day01.modulate(0, &1, MapSet.new(), &1)).() == 0
    assert [+3, +3, +4, -2, -4] |> (&Day01.modulate(0, &1, MapSet.new(), &1)).() == 10
    assert [-6, +3, +8, +5, -6] |> (&Day01.modulate(0, &1, MapSet.new(), &1)).() == 5
    assert [+7, +7, -2, -7, -4] |> (&Day01.modulate(0, &1, MapSet.new(), &1)).() == 14
    assert @input |> Day01.part2 == 464
  end

end
