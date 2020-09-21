defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]


  #render använder eex
  def new(conn), do: send_resp(conn, 200,srender("admin/student/new", []))
  def show(conn, id), do: send_resp(conn, 200,srender("teachers/student/show", student: Student.get(id)))
  def edit(conn, id), do: send_resp(conn, 200,srender("admin/student/edit", [student: Student.get(id), user: User.get_current(conn)]))

  def new(conn, params) do
    Student.create(params)
    redirect(conn, "/admin")
  end

  def update(conn, id, params) do
    Student.update(id, params)
    redirect(conn, "/admin")
  end

  def delete(conn, params) do
    Student.delete(params)
    redirect(conn, "/admin")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
