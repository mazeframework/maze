require "./environment/**"
require "./support/file_encryptor"

module Maze::Environment
  alias EnvType = String | Symbol

  macro included
    class_property path : String = "./config/environments/"
    @@settings : Settings?

    def self.settings
      @@settings ||= Loader.new(env.to_s, path).settings
    rescue Maze::Exceptions::Environment
      @@settings = Settings.from_yaml("default: settings")
    end

    def self.logger
      settings.logger
    end

    def self.env=(env : EnvType)
      @@env = Env.new(env.to_s)
      @@settings = Loader.new(env, path).settings
    end

    def self.env
      @@env ||= Env.new
    end
  end
end
