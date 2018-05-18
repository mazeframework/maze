require "../../../spec_helper"

module Maze::Environment
  describe Settings do
    Dir.cd CURRENT_DIR

    it "loads default environment settings from yaml file" do
      test_yaml = File.read(File.expand_path("./spec/support/config/test.yml"))
      settings = Maze::Settings.from_yaml(test_yaml)

      settings.logger.should be_a Logger
      settings.logging.severity.should eq Logger::WARN
      settings.logging.colorize.should eq true
      settings.database_url.should eq "mysql://root@localhost:3306/test_settings_test"
      settings.host.should eq "0.0.0.0"
      settings.name.should eq "test_settings"
      settings.port.should eq 3000
      settings.port_reuse.should eq true
      settings.process_count.should eq 1
      settings.redis_url.should eq "redis://localhost:6379"
      settings.secret_key_base.should_not be_nil
      settings.secrets.should eq({"description" => "Store your test secrets credentials and settings here."})
      settings.session.should eq({
        :key => "maze.session", :store => :signed_cookie, :expires => 0,
      })
      settings.ssl_key_file.should be_nil
      settings.ssl_cert_file.should be_nil
    end
  end
end
