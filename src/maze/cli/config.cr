module Maze::CLI
  def self.config
    if File.exists? MAZE_YML
      Config.from_yaml File.read(MAZE_YML)
    else
      Config.new
    end
  end

  class Config
    property database : String = "pg"
    property language : String = "slang"
    property model : String = "granite"
    property recipe : (String | Nil) = nil
    property recipe_source : (String | Nil) = nil

    def initialize
    end

    YAML.mapping(
      database: {type: String, default: "pg"},
      language: {type: String, default: "slang"},
      model: {type: String, default: "granite"},
      recipe: String | Nil,
      recipe_source: String | Nil
    )
  end
end
