defmodule Pluggy.Class do
  defstruct(id: nil, name: "")

  alias Pluggy.Class

  def all do
    Postgrex.query!(DB, "SELECT * FROM Classes", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM Classes WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE Classes SET name = $1 WHERE id = $2",
      [name, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]

    Postgrex.query!(DB, "INSERT INTO Classes (name) VALUES ($1)", [name],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM Classes WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name]]) do
    %Class{id: id, name: name}
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Class{id: id, name: name}
  end
end
