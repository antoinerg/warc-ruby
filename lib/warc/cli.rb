require 'warc'
require 'thor'

module Warc
  class CLI < Thor
    desc "dump", "Dump record headers from file"
    def dump(path)
      w=WARC::File.new(path)
      w.each_record do |record|
        puts record.header.to_s
      end
    end
    
  end
end