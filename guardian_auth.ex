defmodule CalciApiWeb.GuardianAuth do
  import Plug.Conn
  import Guardian.Plug
  import Phoenix.Controller
  alias CalciApi.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.verify_token(conn) do
      {:ok, claims} ->
        user = Guardian.resource_from_claims(claims)
        assign(conn, :current_user, user)

      {:error, _reason} ->
        conn
        |> Guardian.Plug.sign_out()
        |> put_flash(:error, "You need to sign in to access this page")
        |> redirect(to: CalciApiWeb.Router.Helpers.session_path(conn, :new))
    end
  end

  defp verify_token(conn) do
    case Guardian.Plug.current_resource(conn) do
      nil -> {:error, :unauthenticated}
      _ -> {:ok, conn}
    end
  end

  defp on_failure(conn, _opts) do
    conn
    |> put_status(401)
    |> json(%{error: "Unauthorized"})
    |> halt()
  end
end
