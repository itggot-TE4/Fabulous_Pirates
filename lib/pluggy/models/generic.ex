defmodule Pluggy.Generic do
  alias Pluggy.Generic

  def all(table, struct) do
    Postgrex.query!(DB, "SELECT * FROM #{table}", [], pool: DBConnection.ConnectionPool)
    |> to_struct_list(struct)
  end

  def get(id, table, struct) do
    num = _transform_id(id)
    Postgrex.query!(DB, "SELECT * FROM #{table} WHERE id = $1 LIMIT 1", [num],
      pool: DBConnection.ConnectionPool
    ) |> to_struct(struct)
  end

  def update(id, params, table) do
    num = _transform_id(id)
    [str, values] = Map.to_list(params) |> set_generator()

    Postgrex.query!(
      DB,
      "UPDATE #{table} SET #{str} WHERE id = $#{Integer.to_string(length(values) + 1)}",
      values ++ [num],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params, table) do
    [str, str2, values] = Map.to_list(params) |> create_generator()

    Postgrex.query!(DB, "INSERT INTO #{table} (#{str}) VALUES (#{str2})", values,
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id, table) do
    num = _transform_id(id)
    Postgrex.query!(DB, "DELETE FROM #{table} WHERE id = $1", [num],
      pool: DBConnection.ConnectionPool
    )
  end


  @doc ~S"""
  Generates the set part of the update postgrex query.

  ## Examples

      iex> Pluggy.Generic.set_generator([{:name, "adrian"}, {:age, 12}])
      [" name = $1,  age = $2", ["adrian", 12]]

      iex> Pluggy.Generic.set_generator([{:name, 12.5}, {:boolean, true}])
      [" name = $1,  boolean = $2", [12.5, true]]

      iex> Pluggy.Generic.set_generator([{:name, 12.5}])
      [" name = $1", [12.5]]

  """
  def set_generator(list), do: set_generator(list, "", [], 1)
  defp set_generator([], str, values_list, _), do: [String.slice(str, 0..-3), values_list]
  defp set_generator(list, str, values_list, counter) do
    [{atom, value} | tail] = list
    temp = "#{str} #{Atom.to_string(atom)} = $#{Integer.to_string(counter)}, "
    [s, val_l] = set_generator(tail, temp, values_list, counter + 1)
    v_l = [value | val_l]
    [s, v_l]
  end


  @doc ~S"""
  Generates parts of the create postrex query

  ## Examples

      iex> Pluggy.Generic.create_generator([{:name, "adrian"}, {:age, 12}])
      [" name,  age", " $1,  $2", ["adrian", 12]]

      iex> Pluggy.Generic.create_generator([{:name, "adrian"}])
      [" name", " $1", ["adrian"]]

  """
  def create_generator(list), do: create_generator(list, "", "", [], 1)
  defp create_generator([], str, str2, values_list, _), do: [String.slice(str, 0..-3),String.slice(str2, 0..-3), values_list]
  defp create_generator(list, str, str2, values_list, counter) do
    [{atom, value} | tail] = list
    temp = "#{str} #{Atom.to_string(atom)}, "
    temp2 = "#{str2} $#{counter}, "
    [s,s2, val_l] = create_generator(tail, temp, temp2, values_list, counter + 1)
    v_l = [value | val_l]
    [s, s2, v_l]
  end


  @doc ~S"""
  Converts a string to a integer if required

  ## Examples

      iex> Pluggy.Generic._transform_id(1)
      1

      iex> Pluggy.Generic._transform_id("1")
      1

  """
  def _transform_id(id) do
    cond do
      is_binary(id) -> String.to_integer(id)
      true -> id
    end
  end


  @doc ~S"""
  Takes a postgrex result struct followed by the module of whitch there is a struct defined
  """
  def to_struct(%Postgrex.Result{columns: collummns, rows: rows}, struct_var, first \\ true) do
    columns = Enum.map(collummns, fn (e)-> String.to_atom(e) end)
    x = Enum.reduce(rows, [], fn(row, acc) ->
          [Enum.zip(columns, row) |> Enum.into(%{}) | acc]
        end)
    if first do
      Enum.map(x, fn(row) -> struct(struct_var) |> Map.merge(row) end) |> List.first()
    else
      Enum.map(x, fn(row) -> struct(struct_var) |> Map.merge(row) end)
    end
  end

  def to_struct_list(data, struct), do: to_struct(data, struct, false) |> Enum.reverse
end
