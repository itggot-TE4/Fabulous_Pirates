defmodule Pluggy.ClassController do
  require IEx

  alias Pluggy.Class
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]

  def new(conn), do: send_resp(conn, 200,srender("admin/classes/new", []))
  def show(conn, id), do: send_resp(conn, 200,srender("teachers/classes/show", class: Class.get_by_school_id(id)))
  def edit(conn, id), do: send_resp(conn, 200,srender("admin/classes/edit", class: Class.get(id)))
  def practice(conn, id), do: send_resp(conn, 200, srender("teachers/classes/practice", class: []))

  def create(conn, params) do
    Class.create(params)
    case params["file"] do
      nil -> IO.puts("No file uploaded")  #do nothing
        # move uploaded file from tmp-folder
      _  -> File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    end
    redirect(conn, "/classes")
  end

  def update(conn, id, params) do
    Class.update(id, params)
    redirect(conn, "/classes")
  end

  def destroy(conn, id) do
    Class.delete(id)
    redirect(conn, "/classes")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
