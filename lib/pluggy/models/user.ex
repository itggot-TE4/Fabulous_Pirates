defmodule Pluggy.User do
  defstruct(id: nil, name: "", username: "", type: 0, img: "")

  require Pluggy.Generic
  alias Pluggy.User


  def get(id) do
    Pluggy.Generic.get(id, "users", User)
  end

  def all() do
    Pluggy.Generic.all("users", User)
  end

    def get_current(conn) do
    session_user = conn.private.plug_session["user_id"]
    current_user =
      case session_user do
        nil -> nil
        _ -> get(session_user)
      end
  end

  def save_img(params) do
    name2 = String.split(params["file"].filename, ".")
    name = "#{List.first(name2)}#{String.slice(to_string(DateTime.utc_now), 0..18)}.#{List.last(name2)}" |> String.split |> Enum.join("")
    File.rename(params["file"].path, "priv/static/uploads/#{String.replace(name, "~r\s", "")}")
    name
  end

end
