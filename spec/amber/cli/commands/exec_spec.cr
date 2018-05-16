require "../../../spec_helper"
require "../../../support/helpers/cli_helper"

include CLIHelper

module Maze::CLI
  describe "maze exec" do
    context "within project" do
      cleanup
      scaffold_app(TESTING_APP)
      `shards`

      it "executes one-liners from the first command-line argument" do
        expected_result = "3000\n"
        MainCommand.run(["exec", "Maze.settings.port"])
        logs = Dir["./tmp/*_console_result.log"].sort

        File.read(logs.last?.to_s).should eq expected_result
      end

      it "executes multi-lines from the command-line argument" do
        expected_result = "one\ntwo\nthree\nnil\n"
        code = <<-CRYSTAL
        %w(one two three).each do |item|
          puts item
        end
        CRYSTAL
        MainCommand.run(["exec", code])
        logs = Dir["./tmp/*_console_result.log"].sort

        File.read(logs.last?.to_s).should eq expected_result
      end

      it "executes a .cr file from the first command-line argument" do
        File.write "maze_exec_spec_test.cr", "puts([:a] + [:b])"
        MainCommand.run(["exec", "maze_exec_spec_test.cr", "-e", "tail"])
        logs = `ls tmp/*_console_result.log`.strip.split(/\s/).sort
        File.read(logs.last?.to_s).should eq "[:a, :b]\n"
        File.delete("maze_exec_spec_test.cr")
      end

      it "opens editor and executes .cr file on close" do
        MainCommand.run(["exec", "-e", "echo 'puts 1000' > "])
        logs = `ls tmp/*_console_result.log`.strip.split(/\s/).sort
        File.read(logs.last?.to_s).should eq "1000\n"
      end

      it "copies previous run into new file for editing and runs it returning results" do
        MainCommand.run(["exec", "1337"])
        MainCommand.run(["exec", "-e", "tail", "-b", "1"])
        logs = `ls tmp/*_console_result.log`.strip.split(/\s/).sort
        File.read(logs.last?.to_s).should eq "1337\n"
      end

      cleanup
    end

    context "outside of project" do
      it "executes outside of project but without including project" do
        expected_result = ":hello\n"
        MainCommand.run(["exec", ":hello"])
        logs = `ls tmp/*_console_result.log`.strip.split(/\s/).sort
        File.read(logs.last?.to_s).should eq expected_result
      end

      # it "errors outside of project if referencing maze specific code" do
      #   MainCommand.run(["exec", "Maze.settings"])
      #   logs = `ls tmp/*_console_result.log`.strip.split(/\s/).sort
      #   File.read(logs.last?.to_s).should contain "undefined constant Maze"
      # end
      cleanup
    end
  end
end
