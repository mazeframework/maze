require "../version"
require "cli"
require "./recipes/recipe"
require "./templates/template"
require "./config"
require "./command"
require "./commands/*"

module Maze::CLI
  include Maze::Environment
  MAZE_YML = ".maze.yml"

  def self.toggle_colors(on_off)
    Colorize.enabled = !on_off
  end

  class MainCommand < ::Cli::Supercommand
    command_name "maze"
    version "Maze CLI (mazeframework.github.io) - v#{VERSION}"

    class Help
      title "\nMaze - Command Line Interface"
      header <<-EOS
        The `maze new` command creates a new Maze application with a default
        directory structure and configuration at the path you specify.

        You can specify extra command-line arguments to be used every time
        `maze new` runs in the .maze.yml configuration file in your project
        root directory

        Note that the arguments specified in the .maze.yml file does not affect the
        defaults values shown above in this help message.

        Usage:
        maze new [app_name] -d [pg | mysql | sqlite] -t [slang | ecr] -m [granite, crecto] --deps
      EOS

      footer <<-EOS
      Example:
        maze new ~/Code/Projects/weblog
        This generates a skeletal Maze installation in ~/Code/Projects/weblog.
      EOS
    end

    class Options
      version desc: "# Prints Maze version"
      help desc: "# Describe available commands and usages"
      string ["-t", "--template"], desc: "# Preconfigure for selected template engine. Options: slang | ecr", default: "slang"
      string ["-d", "--database"], desc: "# Preconfigure for selected database. Options: pg | mysql | sqlite", default: "pg"
      string ["-m", "--model"], desc: "# Preconfigure for selected model. Options: granite | crecto", default: "granite"
      string ["-r", "--recipe"], desc: "# Use a named recipe.  See documentation at https://mazeframework.gitbook.io/maze/.", default: nil
    end
  end
end
