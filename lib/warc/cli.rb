require 'warc'
require 'thor'
require 'rack'

module Warc
  class CLI < Thor
    desc "dump", "Dump record headers from file"
    def dump(path)
      w=Warc.open_stream(path)
      w.each do |record|
        puts "-" * 10
        puts record.header
      end
    end

    desc "proxy", "Start a web proxy serving a WARC file"
    def proxy()
      Rack::Handler::WEBrick.run Warc::Proxy.new
    end
  end
end
