require 'rack'
require 'sinatra/base'

module Warc
  module Proxy
    class Replay < Sinatra::Base
      set :public_dir, File.expand_path('..', __FILE__) # set up the static dir (with images/js/css inside)
      set :views,  File.expand_path('../views', __FILE__) # set up the views dir

      disable :protection

      before do
        headers["Access-ConDrol-Allow-Origin"] = "*"
      end

      get "/" do
        @size = @index.size
        erb :index
      end

      def initialize(app=nil,warc=nil)
        super(app)
        @warc = ::Warc.open_stream(warc)
        @index = {}
        puts "Building index"
        @warc.each do |record|
          if record.header["warc-type"] == "response"
            @index[record.header.uri] = record.offset
          end
        end
        puts "Indexing done"
      end

      def call(env)
        # Send to Sinatra app
        if env["HTTP_HOST"] == "warc"
          super(env)
        # Or serve from archive
        else
          serve(env)
        end
      end

      def serve(env)
        uri = "http://#{env['HTTP_HOST']}#{env['REQUEST_URI']}"
        puts env.inspect
        if @index.key?(uri)
          record = @warc.record(@index[uri])
          return http_response(record)
        else
          return [404,{"Content-Type" => "text/html"},["not found"]]
        end
      end

      def http_response(record)
        io = StringIO.new(record.content)
        headers = {}
        /^HTTP\/(\d\.\d) (\d++) (.*)/.match(io.readline)
        code = $2

        while m = /^(.*): (.*)/.match(io.readline)
          headers[m.captures[0]] = m.captures[1].chomp("\r")
        end
        [code,headers,io]
      end

      def self.start(warc)
        # Run the app!
        app = Rack::Builder.new {
          run Warc::Proxy::Replay.new(nil,warc)
        }
        ::Rack::Server.start(:app => app,:Port => 9292,:server=>:thin)
      end
    end


  end
end