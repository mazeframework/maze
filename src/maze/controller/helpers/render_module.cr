module Maze::Controller::Helpers
  module RenderModule
    LAYOUT = "application.slang"

    # render the template or partial from the same folder as the calling artifact
    macro render_module(template = nil, layout = true, partial = nil, path = "src/views", folder = __DIR__)
      {% if !(template || partial) %}
        raise "Template or partial required!"
      {% end %}

      {{ filename = template || partial }}

      {% if filename.id.split("/").size > 1 %}
        %content = render_module_template("#{{{filename}}}", {{path}})
      {% else %}
        {{ short_path = folder.gsub(/^.+?(?:controllers|views)\//, "") }}
        {% if folder.id.ends_with?(".ecr") %}
          %content = render_module_template("#{{{short_path.gsub(/\/[^\.\/]+\.ecr/, "")}}}/#{{{filename}}}")
        {% else %}
          %content = render_module_template("#{{{short_path.gsub(/\_controller\.cr|\.cr/, "")}}}/#{{{filename}}}")
        {% end %}
      {% end %}

      # Render Layout from the location given by path
      {% if layout && !partial %}
        content = %content
        render_module_template("#{{{path}}}/layouts/#{{{layout.class_name == "StringLiteral" ? layout : LAYOUT}}}")
      {% else %}
        %content
      {% end %}
    end

    private macro render_module_template(filename, path = "src/views")
      {% if filename.id.split("/").size > 2 %}
        Kilt.render("{{filename.id}}")
      {% else %}
        Kilt.render("#{{{path}}}/{{filename.id}}")
      {% end %}
    end
  end
end
