require 'rack'
require 'rack/request'
require 'rack/showexceptions'
require 'webrick'
require 'webrick/httpproxy'

# this allows WEBrick to handle pipe symbols in query parameters
URI::DEFAULT_PARSER =
URI::Parser.new(:UNRESERVED => URI::REGEXP::PATTERN::UNRESERVED + '|')

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

    class Capture
      def self.start(warc)

        Thread.abort_on_exception = true

        warc_stream = Warc::Stream::Gzip.new(warc)
        q=Queue.new

        s=WEBrick::HTTPProxyServer.new({:Port=>9292,
          :ProxyContentHandler => Proc.new{|req,res| q << [req,res]},
          :AccessLog => [["/dev/zero",WEBrick::AccessLog::COMMON_LOG_FORMAT]]
        })

        t=Thread.new do
          loop do
            req,res = q.pop
            #req,res = a[0],a[1]
            unless res.status == 304
              record = Warc::Record.new(res)
              warc_stream.write_record(record)
              puts "Saved block #{record.header.record_id} to archive"
            end
          end
        end
        # Shutdown functionality
        trap("INT"){s.shutdown;t.exit}
        s.start
        t.join
      end
    end
  end
end