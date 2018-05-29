require "../../../spec_helper"

module Maze::Recipes
  describe RecipeFetcher do

    context "using a local folder" do
      Spec.before_each do
        Dir.mkdir_p("./mydefault/app")
        Dir.mkdir_p("./mydefault/controller")
        Dir.mkdir_p("./mydefault/scaffold")
      end

      Spec.after_each do
        FileUtils.rm_rf("./mydefault")
      end

      describe "RecipeFetcher" do
        it "should use a local app folder" do
          template = RecipeFetcher.new("app", "mydefault").fetch
          template.should_not be nil
          template.should match(/.+mydefault\/app$/)
        end

        it "should use a local controller folder" do
          template = RecipeFetcher.new("controller", "mydefault").fetch
          template.should_not be nil
          template.should match(/.+mydefault\/controller$/)
        end
      end
    end

  end
end
