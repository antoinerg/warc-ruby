require 'pathname'

module Warc
  class File
    include Enumerable
    attr_reader :path, :parser
    
    def initialize(path)
      @path = path
      @parser = Warc::Reader.parse(path)
    end
    
    def each &block  
      @parser.each_record do |record|
        if block_given?
          block.call record
        else  
          yield record
        end
      end  
    end
  end
end