defmodule Pluggy.GenericController do
  require IEx

  alias Pluggy.GenericController
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def get_current_user(conn) do
  # get user if logged in
  session_user = conn.private.plug_session["user_id"]
    case session_user do
      nil -> nil
      _ -> User.get(session_user)
    end
  end

  # Displays the given slime file with included params
  defp show_things(conn, path, params), do: send_resp(conn, 200, srender(path, params))
  def show(conn, path, params \\ []), do: show_things(conn, path, params)
  def index(conn, path, params \\ []), do: show_things(conn, path, params)
  def show_new(conn, path, params \\ []), do: show_things(conn, path, params)
  def show_edit(conn, path, params \\ []), do: show_things(conn, path, params)



  def new(conn, redirect_path, params, table, module), do: create(conn, redirect_path, params, table, module)
  def create(conn, redirect_path, params, table, module) do
    # FIXME: I do NOT support image uploads
    # fun = case params["file"] do
    #   nil -> fn(_) -> nil end  #do nothing
    #   _  -> save_img(params)
    # end
    # case fun.() do
    #   nil -> nil
    #   _ -> parameters["img"] = fun.()
    # end

    module.create(params, table)
    redirect(conn, redirect_path)
  end

  def save_img(params) do
    name2 = String.split(params["file"].filename, ".")
    name = "#{List.first(name2)}#{String.slice(to_string(DateTime.utc_now), 0..18)}.#{List.last(name2)}" |> String.split |> Enum.join("")
    File.rename(params["file"].path, "priv/static/uploads/#{String.replace(name, "~r\s", "")}")
    name
  end

  def update(conn, redirect_path, id, params, table, module) do
    module.update(id, params, table)
    redirect(conn, redirect_path)
  end

  def destroy(conn, redirect_path, id, table, module) do
    module.delete(id, table)
    redirect(conn, redirect_path)
  end

  defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
