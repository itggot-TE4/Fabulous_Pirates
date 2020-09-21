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
    Postgrex.query!(DB, "SELECT id, username, img FROM users WHERE id = $1 LIMIT 1", [id],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def to_struct([[id, username, path]]) do
    %User{id: id, username: username, img_path: path}
  end

  def save_img(params) do
    name2 = String.split(params["file"].filename, ".")
    name = "#{List.first(name2)}#{String.slice(to_string(DateTime.utc_now), 0..18)}.#{List.last(name2)}" |> String.split |> Enum.join("")
    File.rename(params["file"].path, "priv/static/uploads/#{String.replace(name, "~r\s", "")}")
    name
  end
end
