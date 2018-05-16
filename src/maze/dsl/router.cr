module Maze::DSL
  record Pipeline, pipeline : Pipe::Pipeline do
    def plug(pipe)
      pipeline.plug pipe
    end
  end

  record Router, router : Maze::Router::Router, valve : Symbol, scope : String do
    RESOURCES = [:get, :post, :put, :patch, :delete, :options, :head, :trace, :connect]

    macro route(verb, resource, controller, action)
      %handler = ->(context : HTTP::Server::Context){
        controller = {{controller.id}}.new(context)
        controller.run_before_filter({{action}}) unless context.content
        unless context.content
          context.content = controller.{{ action.id }}.to_s
          controller.run_after_filter({{action}})
        end
      }
      %verb = {{verb.upcase.id.stringify}}
      %route = Maze::Route.new(
        %verb, {{resource}}, %handler, {{action}}, valve, scope, "{{controller.id}}"
      )

      router.add(%route)
    end

    {% for verb in RESOURCES %}
      macro {{verb.id}}(*args)
        route {{verb}}, \{{*args}}
        {% if verb == :get %}
        route :head, \{{*args}}
        {% end %}
        route {{verb}}, \{{*args}}
        {% if ![:trace, :connect, :options, :head].includes? verb %}
        route :options, \{{*args}}
        {% end %}
      end
    {% end %}

    macro resources(resource, controller, only = nil, except = nil)
      {% actions = [:index, :new, :create, :show, :edit, :update, :destroy] %}

      {% if only %}
        {% actions = only %}
      {% elsif except %}
        {% actions = actions.reject { |i| except.includes? i } %}
      {% end %}

      {% for action in actions %}
        define_action({{resource}}, {{controller}}, {{action}})
      {% end %}
    end

    private macro define_action(path, controller, action)
      {% if action == :index %}
        get "{{path.id}}", {{controller}}, :index
      {% elsif action == :show %}
        get "{{path.id}}/:id", {{controller}}, :show
      {% elsif action == :new %}
        get "{{path.id}}/new", {{controller}}, :new
      {% elsif action == :edit %}
        get "{{path.id}}/:id/edit", {{controller}}, :edit
      {% elsif action == :create %}
        post "{{path.id}}", {{controller}}, :create
      {% elsif action == :update %}
        put "{{path.id}}/:id", {{controller}}, :update
        patch "{{path.id}}/:id", {{controller}}, :update
      {% elsif action == :destroy %}
        delete "{{path.id}}/:id", {{controller}}, :destroy
      {% else %}
        {% raise "Invalid route action '#{action}'" %}
      {% end %}
    end

    def websocket(path, app_socket)
      Maze::WebSockets::Server.create_endpoint(path, app_socket)
    end
  end
end
