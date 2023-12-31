defmodule CalciApiWeb.RegistrationController do
  use CalciApiWeb, :controller
  import CalciApi.Repo
  alias CalciApi.User


  def new(conn, _params) do
    changeset =CalciApi.User.registration_changeset(%User{}, %{}) # Assuming you have a registration_changeset/2 function in your User module
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case CalciApi.UserContext.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Registration successful")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
