require "../../../spec_helper"

describe Maze::Support::FileEncryptor do
  secret_key = "mnDiAY4OyVjqg5u0wvpr0MoBkOGXBeYo7_ysjwsNzmw"
  secret_file = "./tmp/maze_excrypt.enc"
  Dir.mkdir_p("./tmp")
  context "#encryption_key" do
    it "load encryption_key from ENV variable" do
      ENV["MAZE_ENCRYPTION_KEY"] = "fake encryption key"
      Maze::Support::FileEncryptor.encryption_key.should eq "fake encryption key"
    end

    it "load encryption_key from .encryption_key file" do
      ENV["MAZE_ENCRYPTION_KEY"] = nil
      File.write(secret_file, "fake secret key")
      Maze::Support::FileEncryptor.encryption_key(secret_file).should eq "fake secret key"

      # TODO: This is dangerous as this file could be left over.
      File.delete(secret_file)
    end

    it "reads encryption key from file without newline char" do
      ENV["MAZE_ENCRYPTION_KEY"] = nil
      File.write(secret_file, "#{secret_key}\n")
      result = Maze::Support::FileEncryptor.encryption_key(secret_file)
      result.should eq secret_key
      File.delete(secret_file)
    end
  end

  context "read and write global_key" do
    ENV["MAZE_ENCRYPTION_KEY"] = secret_key

    it "writes and encrypted file" do
      Maze::Support::FileEncryptor.write(secret_file, "name: elorest")
      File.exists?(secret_file).should be_truthy
    end

    it "reads encrypted file" do
      result = String.new(Maze::Support::FileEncryptor.read(secret_file))
      result.should eq "name: elorest"
    end

    it "reads encrypted file to string" do
      result = Maze::Support::FileEncryptor.read_as_string(secret_file)
      result.should eq "name: elorest"
    end
  end

  context "read and write with specified key" do
    ENV["MAZE_ENCRYPTION_KEY"] = nil
    it "writes and encrypted file" do
      Maze::Support::FileEncryptor.write(secret_file, "name: elorest", secret_key)
      File.exists?(secret_file).should be_truthy
    end

    it "reads encrypted file" do
      result = String.new(Maze::Support::FileEncryptor.read(secret_file, secret_key))
      result.should eq "name: elorest"
    end
  end
end
