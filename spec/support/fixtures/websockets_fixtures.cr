struct UserSocket < Maze::WebSockets::ClientSocket
  property test_field = Array(String).new

  channel "user_room:*", UserChannel

  def on_disconnect(**args)
    test_field.push("on close #{self.id}")
  end
end

class UserChannel < Maze::WebSockets::Channel
  property test_field = Array(String).new

  def handle_leave(client_socket)
    test_field.push("handle leave #{client_socket.id}")
  end

  def handle_joined(client_socket, msg)
    test_field.push("handle joined #{client_socket.id}")
  end

  def handle_message(client_socket, msg)
    test_field.push(msg["payload"]["message"].as_s)
  end
end
