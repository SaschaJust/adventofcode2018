# Advent of Code 2018

[![Build Status](https://travis-ci.com/SaschaJust/adventofcode2018.svg?branch=master)](https://travis-ci.com/SaschaJust/adventofcode2018)

This repository contains solutions to the [Advent of Code](https://adventofcode.com/2018) puzzles of 2018 in [Elixir](https://elixir-lang.org).

## Usage

First, you have to fetch the dependencies using:
```
mix deps.get
```

Once the dependencies are fetched, you can use all the modules in an interactive session:

```
iex -S mix
```

This will give you an interavtive `iex` session. 
```
Erlang/OTP 21 [erts-10.1.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Compiling 1 file (.ex)
Interactive Elixir (1.7.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> h(Day01)
iex(2)> h(Day01.part1/1)
iex(3)> Utils.load("day_01.input") |> Day01.part1
529
```

### Building

You can build the hex package using:

```
mix hex.build
```

### Tests

You can run the tests (including the puzzle inputs) using:

```
mix test
```

### Documentation

You can build the documentation using:

```
mix docs
```

### Benchmarks

You can run the available benchmarks using:

```
mix bench
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aoc2018` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aoc2018, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc). 
