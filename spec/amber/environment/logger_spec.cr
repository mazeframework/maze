require "../../spec_helper"

module Maze::Environment
  describe Logger do
    describe "#log" do
      it "logs messages with progname" do
        IO.pipe do |r, w|
          logger = Logger.new(w)
          logger.progname = "Maze"
          logger.debug "debug:skip"
          logger.info "info:show"

          logger.level = Logger::DEBUG
          logger.debug "debug:show"

          logger.level = Logger::WARN
          logger.debug "debug:skip:again"
          logger.info "info:skip"
          logger.error "error:show"

          r.gets.should match(/Maze\t| info:show/)
          r.gets.should match(/Maze\t| debug:show/)
          r.gets.should match(/Maze\t| error:show/)
        end
      end
    end
  end
end
