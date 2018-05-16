require "../../spec_helper"

module Maze
  module Pipe
    describe Error do
      it "returns status code 404 when route not found" do
        router = Error.new
        request = HTTP::Request.new("GET", "/")

        response = create_request_and_return_io(router, request)

        response.status_code.should eq 404
      end

      it "returns status code 500 for all other exceptions" do
        error = Error.new
        error.next = ->(context : HTTP::Server::Context) { raise "Oops!" }
        request = HTTP::Request.new("GET", "/")

        Maze::Server.router.draw :web do
          get "/", HelloController, :index
        end

        response = create_request_and_return_io(error, request)

        response.status_code.should eq 500
      end
    end
  end
end
