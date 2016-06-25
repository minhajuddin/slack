defmodule Slack.PageController do
  use Slack.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
