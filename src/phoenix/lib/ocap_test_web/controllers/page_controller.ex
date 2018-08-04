defmodule OcapTestWeb.PageController do
  use OcapTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
