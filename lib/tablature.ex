defmodule Tablature do
  def parse(tab) do
    tab
    |> String.split()
    |> Enum.map(fn t -> parse_line(t) end)              # Parsea cada línea
    |> List.flatten() #Une las listas de tuplas
    |> Enum.sort_by(fn {_num, index} -> index end, :asc) # Ordena por índice
    |> Enum.map(fn {num, _i} -> num end) # Quita el índice
    |> Enum.join(" ")
  end

  def parse_line(line) do
    letter = String.at(line, 0)

    line
    |> String.graphemes() # Se divide en caracteres
    |> Enum.with_index() # Se crea una tupla con el carácter y su índice
    |> Enum.filter(fn {char, i} -> if char =~ ~r/\d/ do {char, i} end end)   # Filtra los dígitos
    |> Enum.map(fn {num, i} -> {letter <> num, i} end)  # Añade la letra a cada dígito
  end
end
