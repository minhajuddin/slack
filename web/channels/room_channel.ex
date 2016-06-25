defmodule Slack.RoomChannel do
  use Phoenix.Channel


  def join(topic, message, socket) do
    {:ok, socket}
  end


  def handle_in("connected", message, socket) do
    push socket, "welcome", %{}
    {:noreply, socket}
  end

  def handle_in("msg", %{"body" => "/block " <> blocked_username, "sender" => sender}, socket) do
    #broadcast socket, "recv_msg", message
    Slack.BlockedUsers.block_sender(sender, blocked_username)
    {:noreply, socket}
  end

  def handle_in("msg", message, socket) do
    broadcast socket, "recv_msg", message
    {:noreply, socket}
  end


  intercept ["recv_msg"]
  def handle_out("recv_msg", message, socket) do
    #message = %{body: message["body"] , id: :crypto.rand_bytes(2) |> Base.encode32}
    #IO.inspect message
    if !Slack.BlockedUsers.is_sender_blocked?(socket.assigns.username, message["sender"]) do
      push socket, "recv_msg", message
    end
    {:noreply, socket}
  end

  Phoenix.Channel
end
