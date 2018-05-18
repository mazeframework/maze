require "../../../../spec_helper"
require "../../../../support/helpers/cli_helper"

require "cli/spec"

include CLIHelper
include Cli::Spec::Helper

module Maze::CLI
  extend Helpers

  describe "maze pipelines" do
    begin
      ENV["CRYSTAL_CLI_ENV"] = "test"

      context "in an `maze new` with default options" do
        cleanup
        scaffold_app(TESTING_APP)
        output = ""

        pipeline_names = %w(web static)

        web_default_plugs = %w(
          Maze::Pipe::PoweredByMaze
          Citrine::I18n::Handler
          Maze::Pipe::Error
          Maze::Pipe::Logger
          Maze::Pipe::Session
          Maze::Pipe::Flash
          Maze::Pipe::CSRF
          Maze::Pipe::Reload
        )

        static_default_plugs = %w(
          Maze::Pipe::PoweredByMaze
          Maze::Pipe::Error
          Maze::Pipe::Static
        )

        pipe_plugs = {
          "web"    => web_default_plugs,
          "static" => static_default_plugs,
        }

        describe "with the default routes" do
          it "runs without an error" do
            MainCommand.run %w(pipelines) { |cmd| output = cmd.out.gets_to_end }
            output.should_not contain "Good bye :("
          end

          MainCommand.run %w(pipelines) { |cmd| output = cmd.out.gets_to_end }
          output_lines = route_table_rows(output)

          it "outputs the correct headers" do
            headers = %w(Pipeline Pipe)
            headers.each do |header|
              output.should contain header
            end
          end

          it "outputs the default pipeline names" do
            pipeline_names.each do |pipeline|
              output.should contain pipeline
            end
          end

          it "outputs the plugs for the pipelines" do
            (web_default_plugs + static_default_plugs).each do |plug|
              output.should contain plug
            end
          end

          it "saves the order of the plugs in the pipeline" do
            pipe_plugs.each do |pipe_name, plugs|
              output_plugs = output_lines.select { |line| line.includes?(pipe_name) }
              plugs.each_with_index do |plug, index|
                output_plug = output_plugs[index]
                (output_plug != nil).should be_true
                output_plug.should contain plug
              end
            end
          end
        end
      end
    ensure
      cleanup
    end
  end
end
