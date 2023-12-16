defmodule CalciApi.Application do
  @moduledoc false

  use Application

  import Supervisor.Spec, warn: false

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CalciApi.Repo,
      # Start the Telemetry supervisor
      CalciApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CalciApi.PubSub},
      # Start the Endpoint (http/https)
      CalciApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CalciApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CalciApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
