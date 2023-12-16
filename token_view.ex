defmodule CalciApiWeb.TokenView do
  use CalciApiWeb, :view
  alias CalciApiWeb.TokenView

  def render("index.json", %{tokens: tokens}) do
    %{data: render_many(tokens, TokenView, "token.json")}
  end

  def render("show.json", %{token: token}) do
    %{data: render_one(token, TokenView, "token.json")}
  end

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
