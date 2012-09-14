require 'warc'
require 'thor'

module Warc
  class CLI < Thor
    desc "dump", "Dump record headers from file"
    def dump(path)
      w=Warc::File.new(path)
      w.each do |record|
        puts "-" * 10
        puts record.header
      end
    end
    
  end
end