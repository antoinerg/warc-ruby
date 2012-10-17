require 'rack'
require 'rack/request'
require 'rack/showexceptions'

module Warc
  module Proxy
    class Replay
      def initialize(warc)
        @warc = ::Warc.open_stream(warc)
        @index = {}
        puts "Building index"
        @warc.each do |record|
          if record.header["warc-type"] == "response"
            @index[record.header.uri] = record.offset
          end
        end
        puts "Index done"
      end

      def call(env)
        uri = env["REQUEST_URI"]
        return homepage if uri == "http://warc/"
        if @index.key?(uri)
          record = @warc.record(@index[uri])
          return http_response(record)
        else
          return [404,{"Content-Type" => "text/html"},["not found"]]
        end
      end

      def homepage
        @html ||= @index.collect {|uri,offset| "<a href='#{uri}'>#{uri}</a><br/>"}
        return [200,{"Content-Type" => "text/html"},@html]
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
        app = ::Rack::Builder.new {
          use ::Rack::ShowExceptions
          use ::Rack::Lint
          use ::Rack::CommonLogger
          run ::Warc::Proxy::Replay.new(warc)
        }
        ::Rack::Server.start(:app => app,:Port => 9292)
      end
    end

    
  end
end