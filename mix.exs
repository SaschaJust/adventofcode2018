defmodule Day07.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc2018,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: "Solutions to the Advent of Code 2018 puzzles.",
      deps: deps(),
      package: package(),
      
      name: "AdventOfCode2018",
      source_url: "https://github.com/SaschaJust/adventofcode2018",
      docs: [
        extras: ["README.md"]
      ] 
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchfella, "~> 0.3.4", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp package() do
    [
      licenses: [ "MIT" ],
      links: %{"GitHub" => "https://github.com/SaschaJust/adventofcode2018"},
    ]
  end
end
