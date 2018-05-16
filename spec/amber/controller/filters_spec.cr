require "../../../spec_helper"

module Maze::Controller
  describe Base do
    describe "controller before and after filters" do
      context "registering action filters" do
        it "registers a before action" do
          controller = build_controller
          controller.before_filters

          before_filters = controller.filters[:before]
          before_filters.size.should eq 5
        end

        it "registers a after action" do
          controller = build_controller
          controller.after_filters

          after_filters = controller.filters[:after]
          after_filters.size.should eq 2
        end
      end

      context "running filters" do
        it "runs before filters" do
          controller = build_controller
          controller.run_before_filter(:index)
          controller.total.should eq 4
        end

        it "runs after filters" do
          controller = build_controller
          controller.run_after_filter(:index)
          controller.total.should eq 2
        end
      end
    end
  end
end
