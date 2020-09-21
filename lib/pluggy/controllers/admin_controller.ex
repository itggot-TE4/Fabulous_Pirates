defmodule Pluggy.AdminController do
  # import Pluggy.Template, only: [render: 2] #det här exemplet renderar inga templates
  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.Template, only: [srender: 1, srender: 2]

  alias Pluggy.User
  alias Pluggy.Class
  alias Pluggy.School
  alias Pluggy.Student


  def new_school_form(conn) do
    send_resp(conn, 200, srender("admin/school/new", user: User.get_current(conn)))
  end

  def new_class_form(conn) do
    send_resp(conn, 200, srender("admin/class/new", user: User.get_current(conn), schools: School.all()))
  end

  def new_student_form(conn, id) do
    send_resp(conn, 200, srender("admin/school/student/new", user: User.get_current(conn), school_id: id, classes: Class.get_by_school_id(id)))
  end

  def index(conn) do
    send_resp(conn, 200, srender("admin/index", [schools: School.all(), classes: Class.all(), students: Student.all(), user: User.get_current(conn)]))
  end
end
