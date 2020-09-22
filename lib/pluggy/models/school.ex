defmodule Pluggy.School do
  defstruct(id: nil, name: "", img: "")

  require Pluggy.Generic
  alias Pluggy.School


  def get(id) do
    Pluggy.Generic.get(id, "schools", School)
  end

  def all() do
    Pluggy.Generic.all("schools", School)
  end

  def get_by_user_id(user) do
    Postgrex.query!(DB, "SELECT Schools.id, name
    FROM Schools
    JOIN User_School_id ON Schools.id = User_school_id.school_id
    JOIN Users ON Users.id = User_School_id.user_id
    WHERE users.id = $1;", [user.id],
    pool: DBConnection.ConnectionPool)
    |> Generic.to_struct_list(School)
  end




end
