require "./base"

module Maze::Controller
  class Static < Base
    # If static resource is not found then raise an exception
    def index
      raise Maze::Exceptions::RouteNotFound.new(request)
    end
  end
end
