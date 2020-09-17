defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.School
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]


  #render använder eex
  def new(conn), do: send_resp(conn, 200, srender("admin/schools/new", []))
  def show(conn, id), do: send_resp(conn, 200, srender("teachers/schools/show", school: School.get_by_user_id(id)))
  def edit(conn, id), do: send_resp(conn, 200, srender("admin/schools/edit", school: School.get(id)))

  def create(conn, params) do
    School.create(params)
    case params["file"] do
      nil -> IO.puts("No file uploaded")  #do nothing
        # move uploaded file from tmp-folder
      _  -> File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    end
    redirect(conn, "/schools")
  end

  def update(conn, id, params) do
    School.update(id, params)
    redirect(conn, "/schools")
  end

  def destroy(conn, id) do
    School.delete(id)
    redirect(conn, "/schools")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
