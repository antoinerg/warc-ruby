require 'warc'
require 'warc/proxy'
require 'thor'

module Warc
  class CLI < Thor
    desc "dump WARC_FILE", "Dump record headers from WARC_FILE"
    method_option :offset, :default => 0, :type => :numeric
    def dump(path)
      w=Warc.open_stream(path)
      puts "WARC filename\toffset\twarc-type\twarc-target-uri\twarc-record-id\tcontent-type\tcontent-length"
      w.each(options[:offset]) do |record|
        puts "#{path}\t#{record.offset}\t#{record.header['warc-type']}\t#{record.header['warc-target-uri']}\t#{record.header['warc-record-id']}\t#{record.header['content-type']}\t#{record.header.content_length}"
      end
    end

    desc "replay WARC_FILE", "Start a HTTP proxy serving request from WARC_FILE. Dashboard available at http://warc/"
    option :p, :default => 9292, :banner => "port"
    def replay(warc)
      Warc::Proxy::Replay.start(warc,options[:p])
    end
  end
end
