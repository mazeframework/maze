# NOTE: Constants should be set before require begins.

ENV["MAZE_ENV"] = "test"
ENV[Maze::Support::ENCRYPT_ENV] = "mnDiAY4OyVjqg5u0wvpr0MoBkOGXBeYo7_ysjwsNzmw"
TEST_PATH         = "spec/support/sample"
PUBLIC_PATH       = TEST_PATH + "/public"
VIEWS_PATH        = TEST_PATH + "/views"
TEST_APP_NAME     = "test_app"
TESTING_APP       = "./tmp/#{TEST_APP_NAME}"
APP_TEMPLATE_PATH = "./src/maze/cli/templates/app"
CURRENT_DIR       = Dir.current

Maze.path = "./spec/support/config"
Maze.env=(ENV["MAZE_ENV"])
Maze.settings.redis_url = ENV["REDIS_URL"] if ENV["REDIS_URL"]?
Maze::CLI.settings.logger = Maze::Environment::Logger.new(nil)
Maze.settings.logger = Maze::Environment::Logger.new(nil)

require "http"
require "spec"
require "../src/maze"
require "../src/maze/cli/commands"
require "./maze/controller/*"
require "./support/fixtures"
require "./support/helpers"

include Helpers
