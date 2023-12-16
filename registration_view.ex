defmodule CalciApiWeb.RegistrationView do
  use CalciApiWeb, :view
  #import CalciApiWeb.Router.Helpers
  import Phoenix.HTML.Link


  def registration_path(conn, action, params \\ []) do
    Routes.registration_path(conn, action, params)
  end

  def render("form.html", assigns) do
    %{changeset: changeset} = assigns
  end
end
