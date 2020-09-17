defmodule Pluggy.User do
  defstruct(id: nil, username: "", img_path: "")

  alias Pluggy.User

  def get_current(conn) do
    session_user = conn.private.plug_session["user_id"]
    current_user =
      case session_user do
        nil -> nil
        _ -> get(session_user)
      end
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def to_struct([[id, username]]) do
    %User{id: id, username: username}
  end

  def save_img(params) do
    name = "#{params["file"].filename ++ to_string(DateTime.utc_now)}"
    File.rename(params["file"].path, "priv/static/uploads/#{name}")
    name
  end
end
