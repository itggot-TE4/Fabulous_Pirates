defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.GenericController
  alias Pluggy.ClassController
  alias Pluggy.UserController
  alias Pluggy.SchoolController
  alias Pluggy.StudentController


  alias Pluggy.User
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

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("/users/logout", do: UserController.logout(conn))


  get("/schools/new", do: GenericController.new(conn, "schools/new", [school: struct(School), path: "schools"]))
  get("/schools/:id/edit", do: GenericController.edit(conn, "schools/edit", [school: School.get(id), path: "schools"]))
  # get("/school/:id/show", do: )


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
