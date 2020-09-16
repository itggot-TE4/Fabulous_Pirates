defmodule Pluggy.Router do
  use Plug.Router
  use Plug.Debugger


  alias Pluggy.ClassController
  alias Pluggy.UserController



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



  get("/classes", do: ClassController.index(conn))
  get("/classes/new", do: ClassController.new(conn))
  get("/classes/:id", do: ClassController.show(conn, id))
  get("/classes/:id/edit", do: ClassController.edit(conn, id))

  post("/classes", do: ClassController.create(conn, conn.body_params))

  # should be put /classes/:id, but put/patch/delete are not supported without hidden inputs
  post("/classes/:id/edit", do: ClassController.update(conn, id, conn.body_params))

  # should be delete /classes/:id, but put/patch/delete are not supported without hidden inputs
  post("/classes/:id/destroy", do: ClassController.destroy(conn, id))

  get("/login", do: UserController.login_form(conn))

  post("/users/login", do: UserController.login(conn, conn.body_params))
  post("/users/logout", do: UserController.logout(conn))

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
