require 'pathname'

module Warc
  class File
    attr_reader :file_handle, :parser
    
    def initialize(path)
      @file_handle = ::File.new(path)
      @parser = Warc::Parser.new(self)
    end
    
    def each_record(&block)
      while record = @parser.next_record
        yield(record)
      end
    end
    
  end
end