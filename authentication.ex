defmodule CalciApiWeb.Plugs.Authentication do
  import Guardian.Plug
  import Plug.Conn
  import Phoenix.Controller, only: [assign: 3, put_flash: 3, redirect: 2]
  import CalciApiWeb.ErrorView

  def init(_opts), do: %{}

  def call(conn, _opts) do
    case verify_token(conn) do
      {:ok, claims} ->
        user = Guardian.resource_from_claims(claims)
        conn = Phoenix.Controller.assign(conn, :current_user, user)

      {:error, _reason} ->
        conn =
          conn
          |> Guardian.Plug.sign_out()
          |> Phoenix.Controller.put_flash(:error, "You need to sign in to access this page")
          |> Phoenix.Controller.redirect(to: CalciApiWeb.Router.Helpers.session_path(conn, :new))
    end
  end

  defp verify_token(conn) do
    case Guardian.Plug.verify_token(conn) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end

  defp on_failure(conn, _opts) do
    conn
    |> Plug.Conn.put_status(401)
    |> Phoenix.View.render(conn, CalciApiWeb.ErrorView, "401.json", error: "Unauthorized")
    |> Plug.Conn.halt()
  end
end
