defmodule Pluggy.Student do
  defstruct(id: nil, student_name: "", class_id: nil, img: "")

  alias Pluggy.Student
  alias Pluggy.User

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

  def get_by_class(id) do
    Postgrex.query!(DB, "SELECT * FROM Students WHERE class_id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> IO.inspect()
    |> to_struct_list()
  end


  def update(id, params) do
    name = params["name"]
    class_id = params["class_id"]
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE Students SET student_name = $1, class_id = $2 WHERE id = $3",
      [name, class_id, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]
    class_id = String.to_integer params["class_id"]
    img = User.save_img(params)

    Postgrex.query!(DB, "INSERT INTO Students (student_name, class_id, img) VALUES ($1, $2)", [name, class_id, img],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM Students WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name, class_id, img]]) do
    %Student{id: id, student_name: name, class_id: class_id, img: img}
  end

  def to_struct_list(rows) do
    for [id, name, class_id, img] <- rows, do: %Student{id: id, student_name: name, class_id: class_id, img: img}
  end
end
