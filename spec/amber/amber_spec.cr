require "../../spec_helper"

struct UserSocket < Maze::WebSockets::ClientSocket; end

struct RoomSocket < Maze::WebSockets::ClientSocket; end

describe Maze do
  describe ".env" do
    it "should return test" do
      Maze.env.test?.should be_truthy
      Maze.env.==(:test).should be_truthy
      Maze.env.==(:development).should be_falsey
      Maze.env.!=(:development).should be_truthy
      Maze.env.!=(:test).should be_falsey
    end
  end

  describe ".env=" do
    context "when switching environments" do
      it "changes environment from TEST to PRODUCTION" do
        current_settings = Maze.settings
        Maze.env = :production
        current_settings.port.should eq 3000
        Maze.settings.port.should eq 4000
      end

      it "sets Maze environment from yaml settings file" do
        current_settings = Maze.settings
        Maze.env = :development
        Maze.settings.name.should eq "development_settings"
      end
    end
  end

  describe Maze::Server do
    describe ".configure" do
      it "overrides current environment settings" do
        Maze.env = :test

        Maze::Server.configure do |server|
          server.name = "Hello World App"
          server.port = 8080
          server.logger = Maze::Environment::Logger.new(STDOUT)
          server.logger.level = ::Logger::INFO
          server.logging.colorize = false
        end

        settings = Maze.settings

        settings.name.should eq "Hello World App"
        settings.port.should eq 8080
        settings.logging.colorize.should eq false
        settings.secret_key_base.should eq "ox7cTo_408i4WZkKZ_5OZZtB5plqJYhD4rxrz2hriA4"
      end

      it "retains environment.yml settings that haven't been overwritten" do
        Maze.env = :test
        expected_session = {:key => "maze.session", :store => :signed_cookie, :expires => 0}
        expected_secrets = {
          "description" => "Store your test secrets credentials and settings here.",
        }

        Maze::Server.configure do |server|
          server.name = "Fake App Name"
          server.port = 8080
        end
        settings = Maze.settings

        settings.name.should eq "Fake App Name"
        settings.port_reuse.should eq true
        settings.redis_url.should eq "redis://localhost:6379"
        settings.logging.colorize.should eq true
        settings.secret_key_base.should eq "ox7cTo_408i4WZkKZ_5OZZtB5plqJYhD4rxrz2hriA4"
        settings.session.should eq expected_session
        settings.port.should eq 8080
        settings.database_url.should eq "mysql://root@localhost:3306/test_settings_test"
        settings.secrets.should eq expected_secrets
      end

      it "defines socket endpoint" do
        Maze::Server.router.socket_routes = [] of NamedTuple(path: String, handler: Maze::WebSockets::Server::Handler)

        Maze::Server.configure do |app|
          pipeline :web do
          end

          routes :web do
            websocket "/user", UserSocket
            websocket "/room", RoomSocket
          end
        end

        router = Maze::Server.router
        websockets = router.socket_routes

        websockets[0][:path].should eq "/user"
        websockets[0][:handler].is_a?(Maze::WebSockets::Server::Handler).should be_true
        websockets[1][:path].should eq "/room"
        websockets[1][:handler].is_a?(Maze::WebSockets::Server::Handler).should be_true
      end
    end
  end
end
