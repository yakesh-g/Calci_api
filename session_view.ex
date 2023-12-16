# lib/calci_api_web/views/session_view.ex

defmodule CalciApiWeb.SessionView do
  use CalciApiWeb, :view

  # Define a session_path/2 function
  def session_path(conn, :new) do
    Routes.session_path(conn, :new)
  end

  # Render function for "error.json"
  def render("error.json", %{message: message}) do
    %{
      data: %{
        error: message
      }
    }
  end

  # Add more render functions for other templates as needed
  def render("some_template.html", assigns) do
    # Render logic for "some_template.html"
  end

  def render("register.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("login.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("protected.json", %{user: user}) do
    %{user: user}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def template_not_found(_template, _view, assigns) do
    %{error: "Template not found: #{inspect(assigns[:template])}"}
  end
end
