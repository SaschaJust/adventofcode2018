defmodule Day02Bench do
  use Benchfella

  bench "Part1: puzzle" do
    Utils.load("day_02.input") |> Day02.part1 |> Tuple.to_list |> Enum.reduce(1, fn x, acc -> x*acc end) 
  end

  bench "Part1: examples" do
    "abcdef" |> Day02.occurance
    "bababc" |> Day02.occurance
    "abbcde" |> Day02.occurance
    "abcccd" |> Day02.occurance
    "aabcdd" |> Day02.occurance
    "abcdee" |> Day02.occurance
    "ababab" |> Day02.occurance
  end

  bench "Part1: checksum" do
    """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """ |> Day02.part1 |> Tuple.to_list |> Enum.reduce(1, fn x, acc -> x*acc end)
  end 

  bench "Part2: examples" do
    """
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
    """ |> Day02.part2
  end

  bench "Part2: puzzle" do
    Utils.load("day_02.input") |> Day02.part2
  end
end