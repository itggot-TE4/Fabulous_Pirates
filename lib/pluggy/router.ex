defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.ClassController
  alias Pluggy.UserController
  alias Pluggy.AdminController
  alias Pluggy.SchoolController
  alias Pluggy.StudentController
  alias Pluggy.IndexController
  alias Pluggy.GameController



  plug(Plug.Static, at: "/", from: :pluggy)
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES -- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  # index page


  # Admin pages
  get("/admin", do: AdminController.index(conn))
  get("/admin/school/new", do: AdminController.new_school_form(conn))
  post("/school/new", do: SchoolController.create(conn, conn.body_params))
  get("/admin/class/new", do: AdminController.new_class_form(conn))
  post("/class/new", do: ClassController.create(conn, conn.body_params))
  post("/school/delete", do: SchoolController.delete(conn, conn.body_params))

  get("/admin/school/:id/student/new", do: AdminController.new_student_form(conn, id))
  post("/school/:id/student/new", do: StudentController.new(conn, conn.body_params))

  # Class pages

  get("/classes", do: ClassController.index(conn))
  get("/classes/new", do: ClassController.new(conn))
  get("/classes/:id", do: ClassController.show(conn, id))
  post("/classes", do: ClassController.create(conn, conn.body_params["id"]))
  post("/classes/delete", do: ClassController.delete(conn, conn.body_params))
  # should be put /classes/:id, but put/patch/delete are not supported without hidden inputs
  # should be delete /classes/:id, but put/patch/delete are not supported without hidden inputs
  post("/classes/:id/destroy", do: ClassController.destroy(conn, id))

  get("/schools", do: ClassController.index(conn))
  get("/schools/new", do: ClassController.new(conn))
  get("/schools/:id", do: ClassController.show(conn, id))

  post("/schools", do: ClassController.create(conn, conn.body_params))
  # should be put /schools/:id, but put/patch/delete are not supported without hidden inputs
  # should be delete /schools/:id, but put/patch/delete are not supported without hidden inputs
  post("/schools/:id/destroy", do: ClassController.destroy(conn, id))


  get("/schools/:id/edit", do: ClassController.edit(conn, conn.params["id"]))
  post("/schools/:id/edit", do: ClassController.update(conn, conn.params["id"], conn.body_params))

  get("classes/:id/practice", do: ClassController.practice(conn, id))

  get("/school/:id/edit", do: SchoolController.edit(conn, conn.params["id"]))
  post("/school/:id/edit", do: SchoolController.update(conn, conn.params["id"], conn.body_params))

  get("/", do: SchoolController.show(conn))

  get("/login", do: UserController.login_form(conn))

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("/users/logout", do: UserController.logout(conn))

  get("/users/new", do: UserController.new_user_form(conn))
  post("/users/new", do: UserController.create_new_user(conn, conn.body_params))

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
