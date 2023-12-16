defmodule CalciApi.Guardian do
  use Guardian, otp_app: :calci_api
  alias CalciApi.{Repo, User}
  alias Bcrypt

  # Other Guardian configuration...

  def subject_for_token(user, _claims) do
    {:ok, %{"user_id" => user.id, "username" => user.email}}
  end

  def resource_from_claims(claims) do
    user_id =
      claims
      |> Map.fetch("user_id")
      |> elem(1)

    username =
      claims
      |> Map.fetch("username")
      |> elem(1)

    user = Repo.get_by(User, id: String.to_integer(user_id), username: username)
    {:ok, user}
  end

  defp put_password_hash(changeset) do
    changeset
    |> Ecto.Changeset.cast_assoc(:password, required: true)
    |> Ecto.Changeset.put_change(:password_hash, Bcrypt.hash_pwd_salt(changeset.changes.password))
  end

  @impl true
  def handle_continue(params, _options) do
    {:ok, params}
  end

  @impl true
  def handle_signed_in(conn, _resource, _opts) do
    conn
  end

  @impl true
  def handle_signed_out(conn, _opts) do
    conn
    |> Guardian.Plug.sign_out()
    |> Guardian.Plug.configure_session(drop: true)
  end

  def init(opts), do: opts

  defmodule Macros do
    defmacro __using__(opts) do
      quote do
        use Guardian, unquote(opts)
        import unquote(__MODULE__)
      end
    end
  end
end
