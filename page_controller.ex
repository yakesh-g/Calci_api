defmodule CalciApiWeb.PageController do
  use CalciApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
