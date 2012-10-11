require 'warc'
require 'warc/proxy'
require 'thor'

module Warc
  class CLI < Thor
    desc "dump", "Dump record headers from file"
    method_option :offset, :default => 0, :type => :numeric
    def dump(path)
      w=Warc.open_stream(path)
      puts "WARC filename\toffset\twarc-type\twarc-target-uri\twarc-record-id\tcontent-type\tcontent-length"
      w.each(options[:offset]) do |record|
        puts "#{path}\t#{record.offset}\t#{record.header['warc-type']}\t#{record.header['warc-target-uri']}\t#{record.header['warc-record-id']}\t#{record.header['content-type']}\t#{record.header.content_length}"
      end
    end

    desc "replay", "Start a web proxy serving a WARC file"
    def replay(warc)
      Warc::Proxy::Replay.start(warc)
    end
    
    desc "proxy", "Start a web proxy to intercept and archive communications"
    def proxy(warc)
      Warc::Proxy::Capture.start(warc)
    end
  end
end
