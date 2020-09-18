defmodule Pluggy.StudentController do
  require IEx

  alias Pluggy.Student
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]


  #render använder eex
  def new(conn), do: send_resp(conn, 200,srender("admin/students/new", [user: User.get_current(conn)]))
  def show(conn, id), do: send_resp(conn, 200,srender("teachers/students/show", [student: Student.get(id), user: User.get_current(conn)]))
  def edit(conn, id), do: send_resp(conn, 200,srender("admin/students/edit", [student: Student.get(id), user: User.get_current(conn)]))

  def new(conn, params) do
    Student.create(params)
    redirect(conn, "/students")
  end

  def update(conn, id, params) do
    Student.update(id, params)
    redirect(conn, "/students")
  end

  def destroy(conn, id) do
    Student.delete(id)
    redirect(conn, "/students")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end
end
