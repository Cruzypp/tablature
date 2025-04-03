defmodule Tablature do
  def parse(tab) do
    tab
    |> String.split()  # Divide por líneas
    |> Enum.chunk_every(6, 6)  # Agrupa de 6 en 6 líneas
    |> Enum.map(fn bloque -> Enum.join(bloque, " ") end)  # Une cada bloque en un string
    |> Enum.map(fn segmento -> parse_segment(segmento) end)  # Procesa cada bloque
    |> Enum.join(" ")  # Une todo en un solo string
  end

  def parse_segment(segment) do
    notas =
      segment
      |> String.split()  # Divide en líneas individuales
      |> Enum.map(fn linea -> parse_line(linea) end)
      |> List.flatten()

    grouped = Enum.group_by(notas, fn {_, i} -> i end) #%{1 => [{"D7", 1},{"D1", 1}, {"A7", 1}] }  Es este tipo de dato

    {min_i, max_i} =
      notas
      |> Enum.map(fn {_, i} -> i end)
      |> Enum.min_max()  # Obtiene el mínimo y máximo índice


      (min_i..max_i)
      |> Enum.filter(fn i ->
        rem(i, 2) != 0 and Map.has_key?(grouped, i) # Se pasan por indices impares y que existan dentro de grouped
        end)
      |> Enum.map(fn i -> same_index(Map.get(grouped, i)) end) # Si i = 1 entones lo que recibe same_index es una lista de tuplas[{"D7", 1}, {"D1", 1}, {"A7", 1}]
      |> Enum.join(" ")
  end

  def parse_line(line) do
    letter = String.at(line, 0)

    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {char, i} ->
      rem(i, 2) != 0 and (char =~ ~r/\d/ or char == "-") # Indices impares de números o guiones
    end)
    |> Enum.map(fn
      {"-", i} -> {"-", i} # Si es guion se queda tal cual
      {num, i} -> {letter <> num, i}
    end)
  end

  def same_index(lista) do
    notas = Enum.map(lista, fn {nota, _} -> nota end)

    if Enum.all?(notas, fn nota -> nota == "-" end) do
      "_"
    else
      notas
      |> Enum.reject(fn nota -> nota == "-" end)
      |> Enum.join("/")
    end
  end
end
