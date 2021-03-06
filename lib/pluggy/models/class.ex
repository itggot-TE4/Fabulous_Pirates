defmodule Pluggy.Class do
  defstruct(id: nil, name: "", img: "", school_id: nil)

  import Pluggy.Generic
  alias Pluggy.Class

  def get(id) do
    Pluggy.Generic.get(id, "classes", Class)
  end

  def all() do
    Pluggy.Generic.all("classes", Class)
  end

  def get_by_school_id(id) do
    Postgrex.query!(DB, "SELECT Classes.id, classes.name, school_id, classes.img
    FROM classes
    JOIN Schools
    ON school_id = Schools.id WHERE Schools.id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool)
    |> to_struct_list(Class)
  end

  def create(params), do: create(params, "classes")
  def delete(params), do: delete(params, "classes")
  def update(id, params), do: update(id, params, "classes")

end
