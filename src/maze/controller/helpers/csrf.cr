module Maze::Controller::Helpers
  module CSRF
    def csrf_token
      Maze::Pipe::CSRF.token(context).to_s
    end

    def csrf_tag
      Maze::Pipe::CSRF.tag(context)
    end

    def csrf_metatag
      Maze::Pipe::CSRF.metatag(context)
    end
  end
end
