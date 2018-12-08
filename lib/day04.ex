defmodule Day04 do
  @moduledoc """
  Addresses the puzzles on [Advent of Code//Day 4](https://adventofcode.com/2018/day/4). 

  ## Day 4: Repose Record

  You've sneaked into another supply closet - this time, it's across from 
  the prototype suit manufacturing lab. You need to sneak inside and fix 
  the issues with the suit, but there's a guard stationed outside the lab, 
  so this is as close as you can safely get.

  As you search the closet for anything that might help, you discover that 
  you're not the first person to want to sneak in. Covering the walls, 
  someone has spent an hour starting every midnight for the past few months 
  secretly observing this guard post! They've been writing down the ID of 
  _the one guard on duty that night_ - the Elves seem to have decided that 
  one guard was enough for the overnight shift - as well as when they fall 
  asleep or wake up while at their post (your puzzle input).

  For example, consider the following records, which have already been 
  organized into chronological order:

  ```
  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-05 00:45] falls asleep
  [1518-11-05 00:55] wakes up
  ```

  Timestamps are written using `year-month-day hour:minute` format. The guard 
  falling asleep or waking up is always the one whose shift most recently 
  started. Because all asleep/awake times are during the midnight hour 
  (`00:00` - `00:59`), only the minute portion (`00` - `59`) is relevant for those 
  events.

  Visually, these records show that the guards are asleep at these times:

  ```
  Date   ID   Minute
              000000000011111111112222222222333333333344444444445555555555
              012345678901234567890123456789012345678901234567890123456789
  11-01  #10  .....####################.....#########################.....
  11-02  #99  ........................................##########..........
  11-03  #10  ........................#####...............................
  11-04  #99  ....................................##########..............
  11-05  #99  .............................................##########.....
  ```

  The columns are Date, which shows the month-day portion of the relevant 
  day; ID, which shows the guard on duty that day; and Minute, which shows 
  the minutes during which the guard was asleep within the midnight hour. 
  (The Minute column's header shows the minute's ten's digit in the first 
  row and the one's digit in the second row.) Awake is shown as `.`, and 
  asleep is shown as `#`.

  Note that guards count as asleep on the minute they fall asleep, and they 
  count as awake on the minute they wake up. For example, because Guard #10 
  wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

  If you can figure out the guard most likely to be asleep at a specific 
  time, you might be able to trick that guard into working tonight so you 
  can have the best chance of sneaking in. You have two strategies for 
  choosing the best guard/minute combination.
  """

  def preprocess(input) do
    input 
    |> String.trim
    |> String.split("\n")
    |> Enum.sort
    |> Enum.map(
      fn x -> Regex.named_captures(~r/\[(?<timestamp>[^\]]+)\]\s+(Guard #(?<id>\d+)|[^\s]+\s(?<state>asleep|up))/, x |> String.trim) 
        |> (&
          {
            NaiveDateTime.from_iso8601!(Map.get(&1, "timestamp") <> ":00.000000Z"), 
            (if Map.get(&1, "id") == "", do: nil, else: String.to_integer(Map.get(&1, "id"))),
            (if Map.get(&1, "state") == "" , do: nil, else: String.to_atom(Map.get(&1, "state")))
          }).()
      end
      ) 
  end

  @doc """
  Solves part 1 of the puzzle.

  ## Description

  _Strategy 1_: Find the guard that has the most minutes asleep. What minute 
  does that guard spend asleep the most?

  In the example above, Guard #10 spent the most minutes asleep, a total of 
  50 minutes (20+25+5), while Guard #99 only slept for a total of 30 
  minutes (10+10+10). Guard _#10_ was asleep most during minute _24_ (on two
  days, whereas any other minute the guard was asleep was only seen on one 
  day).

  While this example listed the entries in chronological order, your 
  entries are in the order you found them. You'll need to organize them 
  before they can be analyzed.

  _What is the ID of the guard you chose multiplied by the minute you chose?_
  (In the above example, the answer would be `10 * 24 = 240`.)

  ## Usage 

  Returns `Integer`.
  """
  def part1(input) do
    input 
    |> preprocess 
    |> p({nil, nil, nil}, %{}, &part1_callback/1)
  end

  @doc """
  Solves part 2 of the puzzle.

  ## Description

  _Strategy 2_: Of all guards, which guard is most frequently asleep on the 
  same minute?

  In the example above, Guard _#99_ spent minute _45_ asleep more than any 
  other guard or minute - three times in total. (In all other cases, any 
  guard spent any minute asleep at most twice.)

  _What is the ID of the guard you chose multiplied by the minute you chose?_
  (In the above example, the answer would be `99 * 45 = 4455`.)

  ## Usage

  Returns `Integer`.
  """
  def part2(input) do
    input 
    |> preprocess 
    |> p({nil, nil, nil}, %{}, &part2_callback/1)
  end


  def part1_callback(map) do
    id = map 
    |> Enum.reduce(%{}, fn {_t, map}, acc -> Map.merge(acc, map, fn _k, v1, v2 -> v1+v2 end) end)
    |> Enum.max_by(fn {_k, v} -> v end)
    |> (fn {k, _v} -> k end).()

    minute = map 
    |> Enum.max_by(fn {_t, map} -> Map.get(map, id) end)
    |> (fn {t, _v} -> t.minute end).()

    minute * id
  end

  def part2_callback(map) do
    map
    |> Enum.max_by(fn {_t, map} -> map |> Enum.max_by(fn {_id, minutes} -> minutes end) |> Tuple.to_list |> Enum.at(1) end)
    |> (fn {t, map} -> [t.minute, map |> Enum.max_by(fn {_id, minutes} -> minutes end) |> Tuple.to_list |> Enum.at(0)] end).()
    |> Enum.reduce(1, &*/2)
  end

  
  def p([], _cache, map, callback) do
    callback.(map)
  end

  def p([current = {timestamp, id, state} | tail], {pt, pi, _ps}, map, callback) do
    p(
      tail, 
      (if id != nil, do: current, else: {timestamp, pi, state}), 
      (if state == :up, do: interval(map, pi, pt, timestamp), else: map), 
      callback
    )
  end

  defp interval(map, id, time1, time2) do
    Stream.unfold(time1, 
      fn n -> 
        if NaiveDateTime.compare(n, time2) == :eq do
          nil
        else 
          {n, NaiveDateTime.add(n, 60, :second)} 
        end
      end
    ) 
    |> Enum.reduce(
      map, 
      fn ts, acc -> 
        Map.update(
          acc, 
          NaiveDateTime.to_time(ts), 
          %{id => 1}, 
          fn x -> Map.update(x, id, 1, &(&1+1)) end
        ) 
      end
    ) 
  end

end
