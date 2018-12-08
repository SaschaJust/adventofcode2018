defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "Part 1: example" do
    assert "dabAcCaCBAcCcaDA" |> Day05.part1 == 10
  end

  test "Part 1: more samples" do
    assert "abcdefgGFEDCBA" |> Day05.part1 == 0
  end

  test "Part 1: puzzle" do
    assert Utils.load("day_05.input") |> Day05.part1 == 11310
  end

  test "React" do 
    assert Day05.react?("a", "A")
    assert Day05.react?("A", "a")
    assert Day05.react?("Z", "z")
    assert not Day05.react?("A", "A")
    assert not Day05.react?("a", "a")
    assert not Day05.react?("a", "B")
    assert not Day05.react?("A", "b")
  end

  test "Part 2: example" do
    assert "dabAcCaCBAcCcaDA" |> Day05.part2 == 4
  end

  test "Part 2: puzzle" do
    assert Utils.load("day_05.input") |> Day05.part2 == 6020
  end
end
