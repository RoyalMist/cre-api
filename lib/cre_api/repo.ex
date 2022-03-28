defmodule CreApi.Repo do
  use Ecto.Repo,
    otp_app: :cre_api,
    adapter: Ecto.Adapters.Postgres
end
