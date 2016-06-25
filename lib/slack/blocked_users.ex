defmodule Slack.BlockedUsers do


  # %{ "khaja" => ["jack", ....]  }
  def start_link do
    Agent.start_link(fn->%{}end, name: __MODULE__)
  end

  def current_state do
    Agent.get(__MODULE__, fn(map)-> map end)
  end

  def is_sender_blocked?(recipient, sender) do
    Agent.get(__MODULE__, fn(map)->
      blocked_users = map[recipient] || []
      sender in blocked_users
    end)
  end

  def block_sender(username, blocked_username) do
    Agent.update(__MODULE__, fn(map)->
      current_blocked_users = map[username] || []
      Map.put(map, username, [blocked_username| current_blocked_users])
    end)
  end
end
