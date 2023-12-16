defmodule CalciApiWeb.Router do
  use CalciApiWeb, :router
  use Guardian.Plug

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline, module: CalciApi.Guardian
    plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
    plug Guardian.Plug.Pipeline,
      error_handler: &CalciApiWeb.GuardianErrorHandler.handle_error/2
  end

  pipeline :auth do
    #plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.Pipeline,
      error_handler: &CalciApiWeb.GuardianErrorHandler.handle_error/2
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CalciApiWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # Unauthenticated API routes
  scope "/api/unauthenticated", CalciApiWeb do
    pipe_through [:api]

    post "/login", SessionController, :create
    post "/register", UserController, :register
  end

  # Authenticated API routes
  scope "/api/authenticated", CalciApiWeb do
    pipe_through [:auth, :api] # Reordered to ensure Guardian.Plug.Pipeline comes after :auth

    post "/calculator/add", CalculatorController, :add
    post "/calculator/subtract", CalculatorController, :subtract
    post "/calculator/divide", CalculatorController, :divide
    post "/calculator/multiply", CalculatorController, :multiply
    post "/calculator/modulo", CalculatorController, :modulo

    get "/protected", SessionController, :protected_action
    #get "/history", CalculatorHistoryController, :index
    get "/calculator/history", CalculatorController, :fetch_history
    #get "/login", SessionController, :create
  end

  # Browser-based UI routes
  scope "/", CalciApiWeb do
    pipe_through :browser

    get "/", PageController, :index
    #get "/login", SessionController, :new
  end

  # User management routes
  scope "/api/users", CalciApiWeb do
    pipe_through :browser

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/show", SessionController, :show
  end

  # Session management routes
  scope "/api/session", CalciApiWeb do
    pipe_through :browser

    #get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  #scope "/session", CalciApiWeb do
    #get "/", SessionController, :index
  #end
end
