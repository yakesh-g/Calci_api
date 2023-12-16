defmodule CalciApiWeb.UserController do
  use CalciApiWeb, :controller
  import CalciApi.Repo

  def register(conn, %{"email" => email, "password" => password}) do
    changeset = %CalciApi.User{}
    |> Ecto.Changeset.cast(%{email: email, password: password}, [:email, :password])
    |> Ecto.Changeset.validate_required([:email, :password])

    case Ecto.Repo.insert(changeset) do
      {:ok, _user} ->
        # Handle successful user registration
        conn
        |> put_status(:created)
        |> render("success.json", message: "User registered successfully")

      {:error, changeset} ->
        # Handle registration errors
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end


  def login(conn, %{"email" => email, "password" => password}) do
    case CalciApi.User.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> render("token.json", token: token)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid email or password"})
    end
  end
end
