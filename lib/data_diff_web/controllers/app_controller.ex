defmodule DataDiffWeb.AppController do
  use DataDiffWeb, :controller

  def index(conn, _) do
    resp(conn, 200, "It works!")
  end
end
