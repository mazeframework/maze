module Maze
  module Pipe
    class PoweredByMaze < Base
      def call(context : HTTP::Server::Context)
        context.response.headers["X-Powered-By"] = "Maze"
        call_next(context)
      end
    end
  end
end
