module Maze::Support
  # Used by `Maze::Pipe::Reload`
  #
  # Allow clients browser reloading using WebSockets and file watchers.
  struct ClientReload
    FILE_TIMESTAMPS = {} of String => String
    WEBSOCKET_PATH  = rand(0x10000000).to_s(36)
    SESSIONS        = [] of HTTP::WebSocket

    def initialize
      create_reload_server
      @app_running = false
      spawn run
    end

    def run
      loop do
        scan_files
        @app_running = true
        sleep 1
      end
    end

    private def create_reload_server
      Maze::WebSockets::Server::Handler.new "/#{WEBSOCKET_PATH}" do |session|
        SESSIONS << session
        session.on_close do
          SESSIONS.delete session
        end
      end
    end

    private def reload_clients(msg)
      SESSIONS.each do |session|
        session.@ws.send msg
      end
    end

    private def check_file(file)
      case file
      when .ends_with? ".css"
        reload_clients(msg: "refreshcss")
      else
        reload_clients(msg: "reload")
      end
    end

    private def get_timestamp(file : String)
      File.stat(file).mtime.to_s("%Y%m%d%H%M%S")
    end

    private def scan_files
      file_counter = 0
      Dir.glob(["public/**/*"]) do |file|
        timestamp = get_timestamp(file)
        if FILE_TIMESTAMPS[file]? != timestamp
          if @app_running
            log "File changed: ./#{file.colorize(:light_gray)}"
          end
          FILE_TIMESTAMPS[file] = timestamp
          file_counter += 1
          check_file(file)
        end
      end
      if file_counter > 0
        log "Watching #{file_counter} files (browser reload)..."
      end
    end

    def log(message)
      Maze.logger.info(message, "Watcher", :light_gray)
    end

    # Code from https://github.com/tapio/live-server/blob/master/injected.html
    INJECTED_CODE = <<-HTML
    <!-- Code injected by Maze Framework -->
    <script type="text/javascript">
      // <![CDATA[  <-- For SVG support
      if ('WebSocket' in window) {
        (function() {
          function refreshCSS() {
            console.log('Reloading CSS...');
            var sheets = [].slice.call(document.getElementsByTagName('link'));
            var head = document.getElementsByTagName('head')[0];
            for (var i = 0; i < sheets.length; ++i) {
              var elem = sheets[i];
              var rel = elem.rel;
              if (elem.href && typeof rel != 'string' || rel.length == 0 || rel.toLowerCase() == 'stylesheet') {
                head.removeChild(elem);
                var url = elem.href.replace(/(&|\\?)_cacheOverride=\\d+/, '');
                elem.href = url + (url.indexOf('?') >= 0 ? '&' : '?') + '_cacheOverride=' + (new Date().valueOf());
                head.appendChild(elem);
              }
            }
          }
          var protocol = window.location.protocol === 'http:' ? 'ws://' : 'wss://';
          var address = protocol + window.location.host + '/#{WEBSOCKET_PATH}';
          var socket = new WebSocket(address);
          socket.onmessage = function(msg) {
            if (msg.data == 'reload') {
              window.location.reload();
            } else if (msg.data == 'refreshcss') {
              refreshCSS();
            }
          };
          socket.onclose = function() {
            console.log('Conection closed!');
            setTimeout(function() {
                window.location.reload();
            }, 1000);
          }
          console.log('Live reload enabled.');
        })();
      }
      // ]]>
    </script>\n
    HTML
  end
end
