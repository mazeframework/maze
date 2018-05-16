module Maze::CLI
  class ErrorTemplate < Teeplate::FileTree
    include Maze::CLI::Helpers
    directory "#{__DIR__}/error"

    @name : String
    @actions : Hash(String, String)
    @language : String = CLI.config.language

    def initialize(@name, actions)
      @actions = actions.map { |action| [action, "get"] }.to_h
      add_plugs
      add_dependencies
    end

    private def add_plugs
      add_plugs :web, "plug Maze::Pipe::Error.new"
    end

    private def add_dependencies
      add_dependencies <<-DEPENDENCY
      require "../src/pipes/error.cr"
      DEPENDENCY
    end

    def filter(entries)
      entries.reject { |entry| entry.path.includes?("src/views") && !entry.path.includes?(".#{@language}") }
    end
  end
end
