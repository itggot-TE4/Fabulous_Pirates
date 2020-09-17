defmodule Pluggy.School do
  defstruct(id: nil, school_name: "")

  alias Pluggy.School

  def all do
    Postgrex.query!(DB, "SELECT * FROM Schools", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM Schools WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def get_by_user_id(id) do
    Postgrex.query!(DB, "SELECT Schools.id, school_name
    FROM Schools
    JOIN User_School_id ON Schools.id = User_school_id.school_id
    JOIN Users ON Users.id = User_School_id.user_id
    WHERE users.id = $1;", [String.to_integer(id)],
    pool: DBConnection.ConnectionPool ).rows
    |> to_struct_list
  end

  def update(id, params) do
    name = params["name"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE Schools SET school_name = $1 WHERE id = $2",
      [name, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]

    Postgrex.query!(DB, "INSERT INTO Schools (school_name) VALUES ($1)", [name],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM Schools WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name]]) do
    %School{id: id, school_name: name}
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %School{id: id, school_name: name}
  end
end
