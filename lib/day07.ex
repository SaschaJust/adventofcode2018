defmodule Day07 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 7](https://adventofcode.com/2018/day/7). 

  ## Day 7: The Sum of Its Parts

  You find yourself standing on a snow-covered coastline; apparently, you 
  landed a little off course. The region is too hilly to see the North Pole 
  from here, but you do spot some Elves that seem to be trying to unpack 
  something that washed ashore. It's quite cold out, so you decide to risk 
  creating a paradox by asking them for directions.

  "Oh, are you the search party?" Somehow, you can understand whatever 
  Elves from the year 1018 speak; you assume it's Ancient Nordic Elvish. 
  Could the device on your wrist also be a translator? "Those clothes don't 
  look very warm; take this." They hand you a heavy coat.

  "We do need to find our way back to the North Pole, but we have higher 
  priorities at the moment. You see, believe it or not, this box contains 
  something that will solve all of Santa's transportation problems - at 
  least, that's what it looks like from the pictures in the instructions." 
  It doesn't seem like they can read whatever language it's in, but you 
  can: "Sleigh kit. Some assembly required."

  "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh'
  at once!" They start excitedly pulling more parts out of the box.

  The instructions specify a series of steps and requirements about which 
  steps must be finished before others can begin (your puzzle input). Each 
  step is designated by a single letter. For example, suppose you have the 
  following instructions:

  ```
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  ```

  Visually, these requirements look like this:

  ```
    -->A--->B--
  /    \\      \\
  C      -->D----->E
  \\           /
    ---->F-----
  ```
  """

  @doc """
  Loads the puzzle input from the file in the 'day_XX' root directory.

  ## Examples

      iex> Utils.load("day_07.input") |> String.slice(0, 4)
      "Step"

  """
  def load do
    case File.read((__ENV__.file |> Path.dirname) <> "/../../day_07.input") do
      {:ok, content} -> content
      _ -> raise "Could not find input file. Please run from the exs file location."
    end
  end

  defp preprocess(input) do
    # Processes the input string to a list of tuples of atoms, 
    # representing the graph.
    input 
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn s -> {s |> String.slice(5,1) |> String.to_atom, s |> String.slice(36,1) |> String.to_atom} end)
  end

  @doc """
  Solves part 1 of the puzzle.

  ## Description

  Your first goal is to determine the order in which the steps should be 
  completed. If more than one step is ready, choose the step which is first 
  alphabetically. In this example, the steps would be completed as follows:

  * Only `C` is available, and so it is done first.
  * Next, both `A` and `F` are available. `A` is first alphabetically, so it is 
    done next.
  * Then, even though `F` was available earlier, steps `B` and `D` are now also 
    available, and `B` is the first alphabetically of the three.
  * After that, only `D` and `F` are available. `E` is not available because 
    only some of its prerequisites are complete. Therefore, `D` is 
    completed next.
  * `F` is the only choice, so it is done next.
  * Finally, `E` is completed.
  
  So, in this example, the correct order is `CABDFE`.

  In what order should the steps in your instructions be completed?
  """
  def part1(input) do
    graph = input |> preprocess
    open = graph 
      |> Enum.reduce(MapSet.new(), fn {dep, target}, acc -> MapSet.put(MapSet.put(acc, target), dep) end) 
      |> Enum.to_list 
      |> Enum.sort
    closed = []

    flatten(graph, open, closed, [])
    |> Enum.map(&Atom.to_string/1) 
    |> Enum.join
  end

  @doc """
  Solves part 2 of the puzzle.

  ## Description

  As you're about to begin construction, four of the Elves offer to help. 
  "The sun will set soon; it'll go faster if we work together." Now, you 
  need to account for multiple people working on steps simultaneously. If 
  multiple steps are available, workers should still begin them in 
  alphabetical order.

  Each step takes 60 seconds plus an amount corresponding to its letter: 
  A=1, B=2, C=3, and so on. So, step A takes `60+1=61` seconds, while step Z 
  takes `60+26=86` seconds. No time is required between steps.

  To simplify things for the example, however, suppose you only have help 
  from one Elf (a total of two workers) and that each step takes 60 fewer 
  seconds (so that step A takes 1 second and step Z takes 26 seconds). 
  Then, using the same instructions as above, this is how each second would 
  be spent:

  ```
  Second   Worker 1   Worker 2   Done
     0        C          .        
     1        C          .        
     2        C          .        
     3        A          F       C
     4        B          F       CA
     5        B          F       CA
     6        D          F       CAB
     7        D          F       CAB
     8        D          F       CAB
     9        D          .       CABF
    10        E          .       CABFD
    11        E          .       CABFD
    12        E          .       CABFD
    13        E          .       CABFD
    14        E          .       CABFD
    15        .          .       CABFDE
  ```

  Each row represents one second of time. The Second column identifies how 
  many seconds have passed as of the beginning of that second. Each worker 
  column shows the step that worker is currently doing (or `.` if they are 
  idle). The Done column shows completed steps.

  Note that the order of the steps has changed; this is because steps now 
  take time to finish and multiple workers can begin multiple steps 
  simultaneously.

  In this example, it would take 15 seconds for two workers to complete 
  these steps.

  With 5 workers and the 60+ second step durations described above, how 
  long will it take to complete all of the steps?

  ## Usage

  This function takes the whole input as a string and returns the total
  time required to execute all tasks given the number of workers and 
  a base penalty,

  Returns `Integer`.
  """
  def part2(input, max_workers \\ 5, penalty \\ 60) do
    # builds the graph
    graph = input 
      |> preprocess

    # fetch list of tasks
    open = graph 
      |> Enum.reduce(MapSet.new(), fn {dep, target}, acc -> MapSet.put(MapSet.put(acc, target), dep) end) 
      |> Enum.to_list 
      |> Enum.sort

    # schedule the tasks
    schedule(graph, open, _closed=[], _workers=[], _time=0, max_workers, penalty)
  end

  @doc """
  Computes the cost for a given task based on the task's identifier.

  ## Examples

      iex> Day07.cost(:A)
      1
      
      iex> Day07.cost(:Z)
      26
  """
  def cost(atom) do
    (atom |> Atom.to_charlist |> List.first ) - ?A + 1
  end

  # Schedule the given tasks (`open_tasks`) using the dependency
  # graph given by `graph`. Initially, cache and workers are empty
  # lists and time starts at `0`. 
  defp schedule(graph, open_tasks, cache, workers, time, max_workers, penalty)

  defp schedule(graph, [], cache, workers, time, max_workers, penalty) do
    prune(graph, cache, [], workers, time, max_workers, penalty)
  end

  defp schedule(graph, list, cache, workers, time, max_workers, penalty) when length(workers) == max_workers do
    prune(graph, list, cache, workers, time, max_workers, penalty)
  end

  defp schedule(graph, _list = [head | tail], cache, workers, time, max_workers, penalty) when length(workers) < max_workers do
    # Check `head` does not depend on anything.
    if not Enum.any?(graph, fn {_dependency, target} -> target == head end) do
      schedule(
        graph,
        tail,
        cache,
        workers ++ [{head, time+penalty+cost(head)}],
        time,
        max_workers,
        penalty
      )
    else
      schedule(graph, tail, cache ++ [head], workers, time, max_workers, penalty)
    end
  end

  defp prune(graph, list, cache, [], time, max_workers, penalty) do
    schedule(graph, list, cache, [], time, max_workers, penalty)
  end

  defp prune(_graph, [], [], workers, _time, _, _) do
    workers 
    |> Enum.max_by(fn {_task, completed} -> completed end)
    |> Tuple.to_list
    |> List.last
  end

  defp prune(graph, list, cache, workers, time, max_workers, penalty) do
    {running, done} = workers |> Enum.split_with(fn {_task, completed} -> completed > time end)
    if done |> Enum.empty? do
      prune(
        graph,
        list,
        cache,
        workers,
        time+1,
        max_workers,
        penalty
      )
    else
      schedule(
        graph |> Enum.filter(fn {dependency, _target} -> Kernel.not(Enum.any?(done, fn {task, _completed} -> task == dependency end)) end),
        list,
        cache,
        running,
        time,
        max_workers,
        penalty
      )
    end
  end

  # Flattens the given graph given by the rules in `Day07.part1/1`.
  defp flatten(graph, tasks, closed, cache) 

  defp flatten(_graph, [], closed, []) do
    closed
  end

  defp flatten(graph, [], closed, cache) do
    flatten(graph, cache, closed, [])
  end

  defp flatten(graph, [head | tail], closed, cache) do
    case graph |> Enum.find( fn {_dependency, target} -> target == head end) do
      nil -> flatten(
          graph |> Enum.filter(fn {dependency, _target} -> dependency != head end),
          cache ++ tail,
          closed ++ [head],
          []
        )
      _ -> flatten(
          graph,
          tail, 
          closed,
          cache ++ [head]
        )
    end
  end

end
