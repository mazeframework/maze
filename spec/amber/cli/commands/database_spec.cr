require "../../../spec_helper"
require "../../../support/helpers/cli_helper"
require "../../../support/fixtures/cli_fixtures"

include CLIHelper
include CLIFixtures

module Maze::CLI
  describe "database" do
    ENV["MAZE_ENV"] = "test"

    describe "sqlite" do
      context ENV["MAZE_ENV"] do
        it "has connection settings in config/environments/env.yml" do
          env_yml = prepare_test_app
          env_yml["database_url"].should eq expected_db_url("sqlite3", env)
        end

        it "does not create the database when db create" do
          env_yml = prepare_test_app
          db_filename = env_yml["database_url"].to_s.gsub("sqlite3:", "")
          File.exists?(db_filename).should be_false
        end

        it "does create the database when db migrate" do
          cleanup
          scaffold_app("#{TESTING_APP}", "-d", "sqlite")
          Maze::CLI.env = "development"
          Maze::CLI.settings.logger = Maze::Environment::Logger.new(nil)
          env_yml = prepare_test_app
          MainCommand.run ["generate", "model", "Post"]
          MainCommand.run ["db", "migrate"]
          db_filename = env_yml["database_url"].to_s.gsub("sqlite3:", "")
          File.exists?(db_filename).should be_true
          File.stat(db_filename).size.should_not eq 0
        end

        it "deletes the database when db drop" do
          env_yml = prepare_test_app
          db_filename = env_yml["database_url"].to_s.gsub("sqlite3:", "")
          MainCommand.run ["generate", "model", "Post"]
          MainCommand.run ["db", "migrate"]
          MainCommand.run ["db", "drop"]
          File.exists?(db_filename).should be_false
        end
      end
    end

    describe "postgres" do
      context ENV["MAZE_ENV"] do
        it "has #{ENV["MAZE_ENV"]}  connection settings" do
          scaffold_app("#{TESTING_APP}", "-d", "pg")
          env_yml = environment_yml(ENV["MAZE_ENV"], "#{Dir.current}/config/environments/")
          env_yml["database_url"].should eq expected_db_url("pg", env)
        end
      end
    end
  end
end
