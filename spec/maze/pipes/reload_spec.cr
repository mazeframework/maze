require "../../spec_helper"

class FakeEnvironment < Maze::Environment::Env
  def development?
    true
  end
end

module Maze
  module Pipe
    describe Reload do
      headers = HTTP::Headers.new
      headers["Accept"] = "text/html"
      request = HTTP::Request.new("GET", "/reload", headers)

      Maze::Server.router.draw :web do
        get "/reload", HelloController, :index
      end

      context "when environment is in development mode" do
        pipeline = Pipeline.new
        pipeline.build :web do
          plug Maze::Pipe::Reload.new(FakeEnvironment.new)
        end
        pipeline.prepare_pipelines

        it "contains injected code in response.body" do
          response = create_request_and_return_io(pipeline, request)

          response.body.should contain "Code injected by Maze Framework"
        end
      end

      context "when environment is NOT in development mode" do
        pipeline = Pipeline.new
        pipeline.build :web do
          plug Maze::Pipe::Reload.new
        end
        pipeline.prepare_pipelines

        it "does not have injected reload code in response.body" do
          response = create_request_and_return_io(pipeline, request)

          response.body.should_not contain "Code injected by Maze Framework"
        end
      end
    end
  end
end
