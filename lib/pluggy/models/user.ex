defmodule Pluggy.User do
  defstruct(id: nil, name: "", username: "", type: 0, img: "", password_hash: "")

  import Pluggy.Generic
  alias Pluggy.User


  def get_by_user_name(username) do
      Postgrex.query!(DB, "SELECT * FROM users WHERE username = $1 LIMIT 1", [username],
        pool: DBConnection.ConnectionPool
      ) |> to_struct(User)
  end

  def get(id) do
    Pluggy.Generic.get(id, "users", User)
  end

  def all() do
    Pluggy.Generic.all("users", User)
  end

end
