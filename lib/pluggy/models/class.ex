defmodule Pluggy.Class do
  defstruct(id: nil, name: "", img: "", school_id: nil)

  require Pluggy.Generic
  alias Pluggy.Class

  def get(id) do
    Pluggy.Generic.get(id, "classes", Class)
  end

  def all() do
    Pluggy.Generic.all("classes", Class)
  end

  def get_by_school_id(id) do
    Postgrex.query!(DB, "SELECT Classes.id, name, school_id
    FROM Classes
    JOIN Schools
    ON school_id = Schools.id WHERE Schools.id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool)
    |> Generic.to_struct_list(Class)
  end


end
