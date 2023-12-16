defmodule CalciApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :calci_api

  # Session configuration
  @session_options [
    store: :cookie,
    key: "_calci_api_key",
    signing_salt: System.get_env("CALCI_API_SIGNING_SALT") || "XmJZVu6l"
  ]

  # LiveView socket configuration
  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Phoenix framework functions
  import Plug.Conn
  import Phoenix.Controller

  # Plug configurations
  plug :accepts, ["json"]

  plug Guardian.Plug.Pipeline,
    module: CalciApi.Guardian,
    token_type: Guardian.JWT,
    serializer: CalciApi.Guardian.Serializer

  plug Plug.Static,
    at: "/",
    from: :calci_api,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  # Code reloading in development
  if Mix.env() == :dev do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :calci_api
  end

  # LiveDashboard configuration
  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  # Other plugs
  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  # Phoenix Router
  plug CalciApiWeb.Router
end
