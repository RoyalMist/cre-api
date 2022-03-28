defmodule CreApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CreApi.Repo,
      CreApiWeb.Telemetry,
      {Phoenix.PubSub, name: CreApi.PubSub},
      CreApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CreApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    CreApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
