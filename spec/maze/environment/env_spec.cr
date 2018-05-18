require "../../../spec_helper"

module Maze::Environment
  describe Env do
    {% for env in %w(development staging test sandbox production) %}
    describe ".{{env.id}}?" do
      it "returns true when the environment is {{env.id}}" do
        maze_env = Env.new {{env}}
        maze_env.{{env.id}}?.should be_truthy
      end

      it "returns false when the environment does not match" do
        maze_env = Env.new "invalid environment"
        maze_env.{{env.id}}?.should be_falsey
      end

      it "returns false when environment name does not have `?` at the end" do
        maze_env = Env.new "invalid environment"
        maze_env.{{env.id}}.should be_falsey
      end

      it "does not return Nil type" do
        maze_env = Env.new "invalid environment"
        maze_env.{{env.id}}.should_not be_nil
      end
    end
    {% end %}

    describe ".==" do
      it "returns true when the environment matches the argument(String)" do
        maze_env = Env.new "staging"
        result = maze_env == "staging"

        result.should be_truthy
      end

      it "returns true when the environment matches the argument(Symbol)" do
        maze_env = Env.new "staging"
        result = maze_env == :staging

        result.should be_truthy
      end

      it "returns false when the environment matches the argument" do
        maze_env = Env.new "invalid"
        result = maze_env == :staging

        result.should be_falsey
      end
    end

    describe "!=" do
      it "returns true when the environment doesn't match the argument" do
        maze_env = Env.new "invalid"
        result = maze_env != :staging

        result.should be_truthy
      end
    end

    describe ".in?" do
      context "when settings environment is in list" do
        it "returns true when array is passed in" do
          maze_env = Env.new "development"

          symbols_result = maze_env.in? %i(development test production)
          strings_result = maze_env.in? %w(development test production)

          symbols_result.should be_truthy
          strings_result.should be_truthy
        end

        it "returns true when tuple is passed in" do
          maze_env = Env.new "development"

          symbols_result = maze_env.in?(:development, :test, :production)
          strings_result = maze_env.in?("development", "test", "production")

          symbols_result.should be_truthy
          strings_result.should be_truthy
        end
      end

      context "when settings environment is not in list" do
        it "returns false" do
          maze_env = Env.new "invalid"

          symbols_result = maze_env.in? %w(development test production)
          strings_result = maze_env.in? %w(development test production)

          symbols_result.should be_falsey
          strings_result.should be_falsey
        end
      end
    end
  end
end
