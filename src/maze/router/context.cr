require "./request"
require "./cookies"
require "./session"
require "./flash"

class HTTP::Server::Context
  METHODS = %i(get post put patch delete head)

  include Maze::Router::Session
  include Maze::Router::Flash

  setter flash : Maze::Router::Flash::FlashStore?
  setter cookies : Maze::Router::Cookies::Store?
  setter session : Maze::Router::Session::AbstractStore?
  property content : String?

  def initialize(@request : HTTP::Request, @response : HTTP::Server::Response)
  end

  def params
    request.params
  end

  def cookies
    @cookies ||= Maze::Router::Cookies::Store.build(request, Maze.settings.secret_key_base)
  end

  def session
    @session ||= Maze::Router::Session::Store.new(cookies, Maze.settings.session).build
  end

  def flash
    @flash ||= Maze::Router::Flash.from_session(session.fetch(Maze::Pipe::Flash::PARAM_KEY, "{}"))
  end

  def websocket?
    request.headers["Upgrade"]? == "websocket"
  end

  # TODO rename this method to something move descriptive
  def valve
    request.route.valve
  end

  {% for method in METHODS %}
  def {{method.id}}?
    request.method == "{{method.id}}"
  end
  {% end %}

  def format
    Maze::Support::MimeTypes.get_request_format(request)
  end

  def port
    request.port
  end

  def requested_url
    request.url
  end

  def halt!(status_code : Int32 = 200, @content = "")
    response.headers["Content-Type"] = "text/plain"
    response.status_code = status_code
  end

  protected def valid_route?
    request.valid_route?
  end

  protected def process_websocket_request
    request.process_websocket.call(self)
  end

  protected def process_request
    request.route.call(self)
  end

  protected def finalize_response
    response.headers["Connection"] = "Keep-Alive"
    response.headers.add("Keep-Alive", "timeout=5, max=10000")
    response.print(@content) unless request.method == "HEAD"
  end
end
