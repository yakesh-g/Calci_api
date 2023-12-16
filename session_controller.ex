defmodule CalciApiWeb.SessionController do
  use CalciApiWeb, :controller
  alias CalciApi.{Repo, User}
  import Ecto.Changeset
  import Comeonin

  #def index(conn) do
    # Render the login form
   # render(conn, "login.html")
  #end

  #def new(conn, _params) do
    # Render the login form
    #render(conn, "login.html")
  #end

  def create(conn, %{"email" => email, "password" => password}) do
    changeset = User.changeset(%User{}, %{email: email, password: password})

    case Repo.insert(changeset) do
      {:ok, user} ->
        authenticate_and_respond(conn, user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  defp authenticate_and_respond(conn, user) do
    case respond_with_token(conn, user) do
      {:ok, conn_with_token} ->
        conn_with_token
      _ ->
        respond_with_auth_error(conn, "Failed to generate token")
    end
  end

  defp respond_with_token(conn, user) do
    claims = %{
      "user_id" => Integer.to_string(user.id),
      "username" => user.email
      # Add any other claims you want to include
    }

    {:ok, token, _claims} = CalciApi.Guardian.encode_and_sign(user, claims)
    json(conn, %{token: token})
  end

  defp respond_with_auth_error(conn, reason) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json", message: "Authentication failed: #{reason}")
  end

  #defp protected_action(conn, _params) do
    #case Guardian.Plug.current_resource(conn) do
      #{:ok, %{"user_id" => user_id, "username" => username}} ->
        #render(conn, "protected_template.html", user_id: user_id, username: username)

      #{:error, _reason} ->
        #conn
        #|> put_status(:unauthorized)
        #|> json(%{error: "Authentication failed"})
    #end
  #end
  defp protected_action(conn, _params) do
    case Guardian.Plug.current_resource(conn) do
      {:ok, claims} ->
        user_id = Map.get(claims, "user_id")
        username = Map.get(claims, "username")

        render(conn, "protected_template.html", user_id: user_id, username: username)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Authentication failed"})
    end
  end
end
