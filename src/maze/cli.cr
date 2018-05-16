require "cli"
require "./version"
require "./exceptions/*"
require "./environment"
require "./cli/commands"

Maze::CLI::MainCommand.run ARGV
