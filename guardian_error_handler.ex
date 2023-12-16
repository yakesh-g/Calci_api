defmodule CalciApiWeb.GuardianErrorHandler do
  use Phoenix.Controller

  def send_json(conn, data) do
    conn
      |> put_resp_content_type("application/json")
      |> Jason.encode(data)
      |> send_resp()
  end

  def handle_error(error, conn) do
    send_json(conn, %{error: error})
  end
end
