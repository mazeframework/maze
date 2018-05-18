require "../../spec_helper"

module Maze
  module Pipe
    describe PoweredByMaze do
      context "Adds X-Powered-By: Maze to response" do
        pipeline = Pipeline.new

        pipeline.build :web do
          plug PoweredByMaze.new
        end

        Maze::Server.router.draw :web do
          options "/poweredbymaze", HelloController, :world
        end

        pipeline.prepare_pipelines

        it "should contain X-Powered-By in response" do
          request = HTTP::Request.new("OPTIONS", "/poweredbymaze")
          response = create_request_and_return_io(pipeline, request)

          response.status_code.should eq 200
          response.headers["X-Powered-By"].should eq "Maze"
          response.body.should contain "Hello World!"
        end
      end
    end
  end
end
