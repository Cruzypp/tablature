defmodule Tablature do
  def parse(tab) do
    notas =
      tab
      |> String.split()
      |> Enum.map(fn line -> parse_line(line) end)
      |> List.flatten()
      |> Enum.filter(fn {_nota, i} -> rem(i, 2) != 0 end)

    grouped = Enum.group_by(notas, fn {_nota, i} -> i end)

    indices =
      grouped
      |> Map.keys()
      |> Enum.sort()

    indices
    |> Enum.map(fn i ->
      same_index(Map.get(grouped, i))
    end)
    |> Enum.join(" ")
  end

  def parse_line(line) do
    letter = String.at(line, 0)

    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {char, i} ->
      rem(i, 2) != 0 and (char =~ ~r/\d/ or char == "-")
    end)
    |> Enum.map(fn
      {char, i} when char == "-" -> {"-", i}
      {num, i} -> {letter <> num, i}
    end)
  end

  def same_index([]), do: "_"

  def same_index(lista) do
    notas = Enum.map(lista, fn {nota, _i} -> nota end)

    if Enum.all?(notas, &(&1 == "-")) do
      "_"
    else
      notas
      |> Enum.reject(&(&1 == "-"))
      |> Enum.join("/")
    end
  end
end
