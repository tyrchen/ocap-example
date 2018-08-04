defmodule PhoenixWeb.PageController do
  use PhoenixWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
