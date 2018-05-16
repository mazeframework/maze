module Maze::WebSockets::Adapters
  # The MemoryAdapter is intended for development use only and shouldn't be used in production.
  class MemoryAdapter
    @listeners = Array(NamedTuple(path: String, listener: Proc(String, JSON::Any, Nil))).new

    def self.instance
      @@instance ||= new
    end

    # On *message* publish, just call all listeners procs
    def publish(topic_path, client_socket, message)
      spawn do
        @listeners.select { |l| l[:path] == topic_path }.each { |l| l[:listener].call(client_socket.id, message) }
      end
    end

    # Add a channel *listener* as a proc
    def on_message(topic_path, listener)
      @listeners.push({path: topic_path, listener: listener})
    end
  end
end
