defmodule Pluggy.Student do
  defstruct(id: nil, name: "", class_id: nil)

  alias Pluggy.Student

  def all do
    Postgrex.query!(DB, "SELECT * FROM Students", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM Students WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    class_id = params["class_id"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE Students SET name = $1, class_id = $2 WHERE id = $3",
      [name, class_id, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]
    class_id = params["class_id"]

    Postgrex.query!(DB, "INSERT INTO Students (name, class_id) VALUES ($1, $2)", [name, class_id],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM Students WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name, class_id]]) do
    %Student{id: id, name: name, class_id: class_id}
  end

  def to_struct_list(rows) do
    for [id, name, class_id] <- rows, do: %Student{id: id, name: name, class_id: class_id}
  end
end
