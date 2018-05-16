module Maze::Router::Session
  # All Session Stores should implement the following API
  abstract class AbstractStore
    abstract def id
    abstract def destroy
    abstract def update(other_hash)
    abstract def set_session
    abstract def current_session
  end
end
