defmodule CreApiWeb.Router do
  use CreApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CreApiWeb do
    pipe_through :api
  end
end
