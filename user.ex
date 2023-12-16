defmodule CalciApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CalciApi.Repo
  alias Guardian.Guardian
  alias CalciApi.User


  schema "users" do
    field :email, :string
    field :password, :string
    field :guardian_token, :string

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        change(changeset, password: password)
    end
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      %User{} = user ->
        case Comeonin.Bcrypt.checkpw(password, user.password) do
          true -> {:ok, user}
          _ -> {:error, "Invalid password"}
        end

      nil -> {:error, "User not found"}
    end
  end

  defp get_user_by_email(email) do
    Repo.find_by(User, email: email)
  end

  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  def create_user(attrs) do
    %User{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_password_hash()
    |> Repo.insert()
  end

  def upsert_user(attrs) do
    Repo.upsert(User, attrs, :email)
    |> put_password_hash()
    |> Repo.update()
  end
end
