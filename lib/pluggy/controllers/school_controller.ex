defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.School
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]


  def new(conn), do: send_resp(conn, 200, srender("admin/schools/new", []))
  def show(conn, id), do: send_resp(conn, 200, srender("teachers/schools/show", school: School.get_by_user_id(id)))
  def edit(conn, id), do: send_resp(conn, 200, srender("admin/schools/edit", school: School.get(id)))

  def create(conn, params) do
    School.create(params)
    redirect(conn, "/admin")
  end

  def update(conn, id, params) do
    School.update(id, params)
    redirect(conn, "/schools")
  end

  def delete(conn, params) do
    School.delete(params)
    redirect(conn, "/schools")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
