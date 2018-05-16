module SessionHelper
  def create_session_config(store)
    Maze.settings.session = {
      "key"     => "name.session",
      "store"   => store,
      "expires" => 120,
    }
    Maze.settings.session
  end
end
