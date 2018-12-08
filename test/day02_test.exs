defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "Part1: examples" do
    assert "abcdef" |> Day02.occurance == { false, false}
    assert "bababc" |> Day02.occurance == { true, true}
    assert "abbcde" |> Day02.occurance == { true, false}
    assert "abcccd" |> Day02.occurance == { false, true}
    assert "aabcdd" |> Day02.occurance == { true, false}
    assert "abcdee" |> Day02.occurance == { true, false}
    assert "ababab" |> Day02.occurance == { false, true}
  end
  

  test "Part1: checksum" do
  assert """
  abcdef
  bababc
  abbcde
  abcccd
  aabcdd
  abcdee
  ababab
  """ |> Day02.part1 |> Tuple.to_list |> Enum.reduce(1, fn x, acc -> x*acc end) == 12
  end 

  test "Part1: puzzle" do
    assert Utils.load("day_02.input") |> Day02.part1 |> Tuple.to_list |> Enum.reduce(1, fn x, acc -> x*acc end) == 5000
  end

  test "Part2: examples" do
    assert """
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """ |> Day02.part2 == "fgij"
  end

  test "Part2: puzzle" do
    assert Utils.load("day_02.input") |> Day02.part2 == "ymdrchgpvwfloluktajxijsqb"
  end
end
