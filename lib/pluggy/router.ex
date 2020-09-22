defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.GenericController
  alias Pluggy.UserController
  alias Pluggy.School
  alias Pluggy.Class
  alias Pluggy.Student



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

  get("/", do: GenericController.show(conn, "index", schools: School.all()))
  get("/schools/:id", do: GenericController.show(conn, "schools/show", school: School.get(id), classes: Class.get_by_school_id(id)))
  get("/schools/:school_id/classes/:id", do: GenericController.show(conn, "schools/classes/show", school: School.get(school_id), class: Class.get(id), students: Student.get_by_class(id)))

  get("/login", do: UserController.show_login(conn))
  post("/login", do: UserController.login(conn, conn.body_params))
  post("/logout", do: UserController.logout(conn))

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
