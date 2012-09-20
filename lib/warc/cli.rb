require 'warc'
require 'thor'

module Warc
  class CLI < Thor
    desc "dump", "Dump record headers from file"
    method_option :offset, :default => 0, :type => :numeric
    def dump(path)
      w=Warc.open_stream(path)
      w.each(options[:offset]) do |record|
        puts "-" * 10
        puts record.header
      end
    end

    desc "proxy", "Start a web proxy serving a WARC file"
    def proxy(warc)
      Warc::Proxy.start(warc)
    end
  end
end
