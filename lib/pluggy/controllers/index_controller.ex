defmodule Pluggy.IndexController do

  alias Pluggy.Index
  alias Pluggy.User

  import Plug.Conn, only: [send_resp: 3]
  import Pluggy.Template, only: [srender: 1, srender: 2]

  def index(conn) do
    send_resp(conn, 200, srender("/index", [ user: User.get_current(conn) ] ))
  end
end
