require "./field.cr"

module Maze::CLI
  class Mailer < Teeplate::FileTree
    include Maze::CLI::Helpers
    directory "#{__DIR__}/mailer"

    @name : String
    @language : String
    @fields : Array(Field)

    def initialize(@name, fields)
      @language = CLI.config.language
      @fields = fields.map { |field| Field.new(field) }

      add_dependencies <<-DEPENDENCY
      require "../src/mailers/**"
      DEPENDENCY
    end

    def filter(entries)
      entries.reject { |entry| entry.path.includes?("src/views") && !entry.path.includes?("#{@language}") }
    end
  end
end
