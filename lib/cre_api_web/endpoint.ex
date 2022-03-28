defmodule CreApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cre_api

  @session_options [
    store: :cookie,
    key: "_cre_api_key",
    signing_salt: "9QWl7A/8"
  ]

  plug Plug.Static,
    at: "/",
    from: :cre_api,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :cre_api
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CreApiWeb.Router
end
