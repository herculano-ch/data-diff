defmodule DataDiffWeb.Router do
  use DataDiffWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DataDiffWeb do
    pipe_through :api

    get "/", AppController, :index
    post "/upload", FileController, :upload
  end
end
