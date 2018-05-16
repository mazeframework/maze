require "../../support/client_reload"

module Maze
  module Pipe
    # Reload clients browsers using `ClientReload`.
    #
    # NOTE: Maze::Pipe::Reload is intended for use in a development environment.
    # ```
    # pipeline :web do
    #   plug Maze::Pipe::Reload.new
    # end
    # ```
    class Reload < Base
      def initialize(@env : Maze::Environment::Env = Maze.env)
        Support::ClientReload.new
      end

      def call(context : HTTP::Server::Context)
        if @env.development? && context.format == "html"
          context.response << Support::ClientReload::INJECTED_CODE
        end
        call_next(context)
      end
    end
  end
end
