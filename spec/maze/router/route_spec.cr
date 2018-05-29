require "../../../spec_helper"

module Maze
  describe Route do
    handler = ->(_context : HTTP::Server::Context) {}
    subject = Route.new("GET", "/fake/action/:id/:name", handler, :action, :web, "", "FakeController")

    it "Initializes correctly with Descendant controller" do
      request = HTTP::Request.new("GET", "/?test=test")
      create_context(request)

      route = Route.new("GET", "/", handler)

      route.class.should eq Route
    end

    describe "#substitute_keys_in_path" do
      it "parses route resource params" do
        params = {"id" => "123", "name" => "John"}
        empty_hash = {} of String => String
        subject.substitute_keys_in_path(params).should eq({"/fake/action/123/John", empty_hash})
      end
    end

    describe "#call" do
      context "before action" do
        it "does not execute action" do
          handler = ->(context : HTTP::Server::Context) {
            controller = FakeController.new(context)
            controller.run_before_filter(:halt_action) unless context.content
            unless context.content
              controller.halt_action
              controller.run_after_filter(:halt_action)
            end
          }

          request = HTTP::Request.new("GET", "")
          context = create_context(request)
          route = Route.new("GET", "", handler)

          route.call(context)
          context.response.status_code.should eq 900
          context.content.should eq ""
        end
      end

      context "when redirecting" do
        it "halts request execution" do
          new_handler = ->(context : HTTP::Server::Context) {
            controller = FakeRedirectController.new(context)
            controller.run_before_filter(:redirect_action) unless context.content
            unless context.content
              controller.redirect_action
              controller.run_after_filter(:redirect_action)
            end
          }

          request = HTTP::Request.new("GET", "/")
          context = create_context(request)
          route = Route.new("GET", "", new_handler, :redirect_action)

          route.call(context)
          context.response.status_code.should eq 302
          context.content.should eq "Redirecting to /"
        end
      end
    end
  end
end

class FakeController < Maze::Controller::Base
  before_action do
    only :halt_action { halt!(900) }
  end

  def halt_action
    raise "Should not reach this action"
    ""
  end
end

class FakeRedirectController < Maze::Controller::Base
  def redirect_action
    redirect_to "/"
    ""
  end
end
