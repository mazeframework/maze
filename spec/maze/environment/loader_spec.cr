require "../../../spec_helper"

module Maze::Environment
  describe Loader do
    Dir.cd CURRENT_DIR

    it "raises error for non existent environment settings" do
      expect_raises Maze::Exceptions::Environment do
        Loader.new("unknown", "./spec/support/config/")
      end
    end

    it "load settings from YAML file" do
      environment = Loader.new(:fake_env, "./spec/support/config/")
      environment.settings.should be_a Maze::Environment::Settings
    end

    it "loads encrypted YAML settings" do
      environment = Loader.new(:production, "./spec/support/config/")
      environment.settings.should be_a Maze::Environment::Settings
    end
  end
end
