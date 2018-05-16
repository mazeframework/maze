require "http"

module Maze
  module Pipe
    # Base class to include the HTTP::Handler module.
    class Base
      include HTTP::Handler

      # Execution of this handler.
      def call(context : HTTP::Server::Context)
        call_next(context)
      end
    end
  end
end
