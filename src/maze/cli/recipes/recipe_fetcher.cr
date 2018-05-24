require "http/client"
require "zip"

module Maze::Recipes
  class RecipeFetcher
    getter kind : String # one of the supported kinds [app, controller, scaffold]
    getter name : String
    getter directory : String
    getter app_dir : String | Nil

    def initialize(@kind : String, @name : String, @app_dir = nil)
      @directory = "#{Dir.current}/#{@name}/#{@kind}"
    end

    def fetch
      # try the current folder
      if Dir.exists?(@directory)
        return @directory
      end

      # try absolute path
      if Dir.exists?("#{@name}/#{@kind}")
        return "#{@name}/#{@kind}"
      end

      parts = @name.split("/")

      recipes_folder = @kind == "app" ? "#{app_dir}/.recipes" : "./.recipes"

      if parts.size == 2
        # this could be a github repository
        # take the last component as the shard name
        shard_name = parts[-1]

        # determine if the recipe exists in the current .recipes folder
        # installed by shards and we are not generating an app
        if shard_name && @kind != "app"
          if Dir.exists?("#{recipes_folder}/lib/#{shard_name}/#{@kind}")
            return "#{recipes_folder}/lib/#{shard_name}/#{@kind}"
          end
          return nil
        end

        if shard_name && @kind == "app" && try_github
          fetch_github shard_name
          if Dir.exists?("#{recipes_folder}/lib/#{shard_name}/#{@kind}")
            return "#{recipes_folder}/lib/#{shard_name}/#{@kind}"
          end
        end
      end

      template_path = "#{recipes_folder}/zip/#{@name}"

      if Dir.exists?("#{template_path}/#{@kind}")
        return "#{template_path}/#{@kind}"
      end

      if @name.downcase.starts_with?("http") && @name.downcase.ends_with?(".zip")
        return fetch_zip @name, template_path
      end

      return fetch_url template_path
    end

    def try_github
      # if the recipe is a github shard repository (has a shard.yml)
      url = "https://raw.githubusercontent.com/#{@name}/master/shard.yml"

      HTTP::Client.get(url) do |response|
        if response.status_code == 200
          return true
        end
      end
      false
    end

    # create a shard.yml to install dependencies
    def create_recipe_shard(shard_name)
      dirname = "#{app_dir}/.recipes"
      Dir.mkdir_p(dirname)
      filename = "#{dirname}/shard.yml"

      yaml = {name: "recipe", version: "0.1.0", dependencies: {shard_name => {github: @name, branch: "master"} }}

      CLI.logger.info "Create Recipe shard #{filename}", "Generate", :light_cyan
      File.open(filename, "w") { |f| yaml.to_yaml(f) }
    end


    def fetch_github(shard_name)
      create_recipe_shard shard_name

      CLI.logger.info "Installing Recipe", "Generate", :light_cyan
      Maze::CLI::Helpers.run("cd #{app_dir}/.recipes && shards update")
    end

    def recipe_source
      CLI.config.recipe_source || "https://raw.githubusercontent.com/mazeframework/recipes/master/dist"
    end

    def fetch_zip(url : String, template_path : String)
      # download the recipe zip file from the github repository
      HTTP::Client.get(url) do |response|
        if response.status_code != 200
          CLI.logger.error "Could not find the recipe #{@name} : #{response.status_code} #{response.status_message}", "Generate", :light_red
          return nil
        end

        # make a temp directory and expand the zip into the temp directory
        Dir.mkdir_p(template_path)

        Zip::Reader.open(response.body_io) do |zip|
          zip.each_entry do |entry|
            path = "#{template_path}/#{entry.filename}"
            if entry.dir?
              Dir.mkdir_p(path)
            else
              File.write(path, entry.io.gets_to_end)
            end
          end
        end
      end

      # return the path of the template directory
      if Dir.exists?("#{template_path}/#{@kind}")
        return "#{template_path}/#{@kind}"
      end

      CLI.logger.error "Cannot generate #{@kind} from #{@name} recipe", "Generate", :light_red
      return nil
    end

    def fetch_url(template_path : String)
      return fetch_zip "#{recipe_source}/#{@name}.zip", template_path
    end

  end
end
