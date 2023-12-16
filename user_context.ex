defmodule CalciApi.UserContext do
  import Ecto.Query
  alias CalciApi.Repo
  alias CalciApi.User
  alias CalciApi.User.Token

  # User Functions
  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> handle_insert_result
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> handle_update_result
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
    |> handle_delete_result
  end

  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def list_users do
    Repo.all(User)
  end

  # Token Functions
  def create_token(attrs) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
    |> handle_insert_result
  end

  def get_token_by_id(id) do
    Repo.get(Token, id)
  end

  def list_tokens do
    Repo.all(Token)
  end

  # Authentication Functions
  def authenticate_user(email, password) do
    case Repo.get_by(User, email: email) do
      %User{} = user ->
        case Comeonin.Bcrypt.checkpw(password, user.password) do
          true -> {:ok, user}
          _ -> {:error, "Invalid password"}
        end

      nil -> {:error, "User not found"}
    end
  end

  # Helper Functions
  defp handle_insert_result({:ok, inserted_entity}), do: {:ok, inserted_entity}
  defp handle_insert_result({:error, reason}), do: {:error, reason}

  defp handle_update_result({:ok, updated_entity}), do: {:ok, updated_entity}
  defp handle_update_result({:error, changeset}), do: {:error, changeset.errors}

  defp handle_delete_result(:ok), do: {:ok}
  defp handle_delete_result({:error, reason}), do: {:error, reason}
end
