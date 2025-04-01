defmodule Tablature do
  def parse(tab) do
    tab |> String.split()
    |> Enum.map(fn line -> parse_line(line) end)
    |> Enum.filter(fn l -> length(l) > 0 end)
    |> Enum.zip
    |> Enum.map(fn t -> Tuple.to_list(t) end)
    |> List.flatten
    |> Enum.join(" ")
  end

  def parse_line(line) do
    letter = String.at(line, 0)
    line |> String.graphemes |> Enum.filter(fn c -> c =~ ~r/\d/ end) |> Enum.map(fn d -> letter <> d end)
  end
end
