abstract class Command < Cli::Command
  def puts(msg)
    Maze::CLI.logger.info msg, Class.name, :light_cyan
  end
end
