
defmodule Pluggy.SchoolController do
  require IEx

  alias Pluggy.School
  alias Pluggy.User

  import Pluggy.GenericController

  import Pluggy.Template, only: [render: 2, srender: 2]
  import Plug.Conn, only: [send_resp: 3]





end
