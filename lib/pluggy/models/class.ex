defmodule Pluggy.Class do
  defstruct(id: nil, name: "", school_id: nil)

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
    school_id = params["school_id"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE Classes SET class_name = $1, school_id = $2  WHERE id = $3",
      [name, school_id, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]
    school_id = params["school_id"]

    Postgrex.query!(DB, "INSERT INTO Classes (class_name, school_id) VALUES ($1, $2)", [name, school_id],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM Classes WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name, school_id]]) do
    %Class{id: id, name: name, school_id: school_id}
  end

  def to_struct_list(rows) do
    for [id, name, school_id] <- rows, do: %Class{id: id, name: name, school_id: school_id}
  end
end
