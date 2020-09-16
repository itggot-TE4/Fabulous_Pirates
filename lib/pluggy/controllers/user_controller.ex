defmodule Pluggy.UserController do
  # import Pluggy.Template, only: [render: 2] #det här exemplet renderar inga templates
  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.Template, only: [srender: 1, srender: 2]
  import Pluggy.User

  def login(conn, params) do
    username = params["name"]
    password = params["password"]

     #Bör antagligen flytta SQL-anropet till user-model (t.ex User.find)
    result =
      Postgrex.query!(DB, "SELECT id, password_hash FROM users WHERE username = $1", [username],
        pool: DBConnection.ConnectionPool
      )


    case result.num_rows do
      # no user with that username
      0 ->
        redirect(conn, "/fruits")
      # user with that username exists
      _ ->
        [[id, password_hash]] = result.rows

        # make sure password is correct
        if Bcrypt.verify_pass(password, password_hash) do
          Plug.Conn.put_session(conn, :user_id, id)
          |> redirect("/fruits") #skicka vidare modifierad conn
        else
          redirect(conn, "/fruits")
        end
    end
  end

  def logout(conn) do
    Plug.Conn.configure_session(conn, drop: true) #tömmer sessionen
    |> redirect("/fruits")
  end

  def login_form(conn) do
    # IO.puts(conn)
    send_resp(conn, 200, srender("users/login"))
  end

  defp redirect(conn, url),
    do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

  def new_user_form(conn) do
    session_user = conn.private.plug_session["user_id"]
    current_user =
      case session_user do
        nil -> nil
        _ -> get(session_user)
      end
    send_resp(conn, 200, srender("users/new", user: current_user))
  end

  def create_new_user(conn, params) do
    case params["file"] do
      nil -> Postgrex.query!(DB, "INSERT INTO Users(name, username, type, password_hash) VALUES($1, $2, $3, $4)", [params["name"], params["user_name"], "Admin", Tuple.to_list(Map.fetch(Bcrypt.add_hash(params["password"]), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)
      _  -> fn ->
        Postgrex.query!(DB, "INSERT INTO Users(name, username, type, password_hash, img) VALUES($1, $2, $3, $4)", [params["name"], params["user_name"], "Admin", Tuple.to_list(Map.fetch(Bcrypt.add_hash(params["password"], save_img(params)), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)  end
    end
    redirect(conn, "/fruits")
  end
end
