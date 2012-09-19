require 'pathname'

module Warc
  def self.open_stream(path)
    fh = ::File.new(path,'r+')
    if Pathname.new(path).extname == '.gz'
      Stream::Gzip.new(fh)
    else
      Stream::Plain.new(fh)
    end
  end

  class Stream
    include Enumerable
    attr_reader :parser
    def initialize(fh)
      fh = case fh
      when ::File 
        file_handle = fh
      when String
        ::File.new(fh,'a+')
      end
      @file_handle=fh
      @parser = ::Warc::Parser.new
    end

    def each(&block)
      loop do
        rec = self.read_record
        if rec
          if block_given?
            block.call(rec)
          else
            yield rec
          end
        else
          break
        end
      end
    end
    
    def close
      @file_handle.close
    end
      
    def read_record
      raise StandardError
    end
      
    def write_record(record)
      raise StandardError
    end
  end
end
