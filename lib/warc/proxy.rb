require 'rack'
require 'rack/request'
require 'rack/showexceptions'

module Warc
  class Proxy
    def initialize(warc)
      @warc = ::Warc.open_stream(warc)
    end
    
    def call(env)
      req = ::Rack::Request.new(env)
      page = @warc.detect do |rec|
        rec.header["warc-target-uri"] == req.url &&
        rec.header["warc-type"] == "response"
      end
      if page
        return http_response(page)
      else
        [200,{"Content-Type" => "text/html"},["Not found"]]
      end
    end
    
    def http_response(page)
      io = StringIO.new(page.content)
      headers = {}
      io.readline
      while m = /^(.*): (.*)/.match(io.readline)
          headers[m.captures[0]] = m.captures[1].chomp("\r")
      end
      [200,headers,io]
    end
    
    def self.start(warc)
      app = ::Rack::Builder.new {
        use ::Rack::ShowExceptions
        #use ::Rack::Lint
        use ::Rack::CommonLogger
        
        map "/" do
          run ::Warc::Proxy.new(warc)
        end
      }
      ::Rack::Server.start(:app => app,:Port => 9292)
    end
  end
end