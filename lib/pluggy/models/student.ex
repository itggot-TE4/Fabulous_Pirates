defmodule Pluggy.Student do
  defstruct(id: nil, name: "", img: "", class_id: nil)

  require Pluggy.Generic
  alias Pluggy.Student


  def get(id) do
    Pluggy.Generic.get(id, "students", Student)
  end

  def all() do
    Pluggy.Generic.all("students", Student)
  end

  def get_by_class(id) do
    Postgrex.query!(DB, "SELECT * FROM Students WHERE class_id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
    |> Generic.to_struct_list(Student)
  end

end
