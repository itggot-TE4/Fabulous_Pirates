defmodule Pluggy.User do
  defstruct(id: nil, name: "", username: "", type: 0, img: "")

  require Pluggy.Generic
  alias Pluggy.User


  def get(id) do
    Pluggy.Generic.get(id, "users", User)
  end

  def all() do
    Pluggy.Generic.all("users", User)
  end

end
