defmodule Tablature do
  def parse(tab) do
    notas =
      tab
      |> String.split()
      |> Enum.map(fn line -> parse_line(line) end)
      |> List.flatten()
      |> Enum.filter(fn {_nota, i} -> rem(i, 2) != 0 end)

    grouped = Enum.group_by(notas, fn {_nota, i} -> i end) #%{1 => [{"D7", 1},{"D1", 1}, {"A7", 1}] }  Es este tipo de dato

    indices = # Se optiene una lista de indices [1,2,3]
      grouped
      |> Map.keys()
      |> Enum.sort()

    # Devuelve todos los elementos de la lista que tengan el mismo indice
    # Si i = 1 entones lo que recibe same_index es una lista de tuplas[{"D7", 1}, {"D1", 1}, {"A7", 1}]
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
      rem(i, 2) != 0 and (char =~ ~r/\d/ or char == "-") # Se toman indices impares y que sean numeros o "-"
    end)
    |> Enum.map(fn
      {nota, i} when nota == "-" -> {"-", i} # Si la nota "-" se devuelve como esta
      {nota, i} -> {letter <> nota, i} # Si la nota no es "-" se concatena la letra a la nota
    end)
  end

  def same_index(lista) do
    notas = Enum.map(lista, fn {nota, _i} -> nota end)

    # notas es []
    if Enum.all?(notas, fn nota -> nota == "-" end) do # En caso de que todos los elementos de la lista sean "-"
      "_" # Es un silencio
    else
      notas
      |> Enum.reject(fn x -> x == "-" end) # Se ignoran los "-"
      |> Enum.join("/") # Se unen las notas con "/"
    end
  end
end
