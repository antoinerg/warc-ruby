require 'pathname'

module Warc
  def self.open_stream(path,mode='r+')
        
    gzipped = path.match(/.*\.warc\.gz$/)
    warc = path.match(/.*\.warc$/)
    
    if (gzipped || warc)
      fh = ::File.exists?(path) ? ::File.new(path,mode) : path
      return Stream::Gzip.new(fh) if gzipped
      return Stream::Plain.new(fh) if warc
    else
      return Stream::Gzip.new(path)
    end
  end

  class Stream
    private_class_method :new
    include Enumerable
    attr_reader :parser
    
    DEFAULT_OPTS = {
      # Maximum file size 
      :max_filesize => 10**9
    }
    
    def initialize(fh,options={},&block)
      @options = DEFAULT_OPTS.merge options
      @index = 0
      fh = case fh
      when ::File
        @name = ::File.basename(fh)
        fh
      when String
        @name = fh
        @naming_proc = block || lambda {|name,index| "#{name}.#{sprintf('%06d',index)}"} 
        next_file_handle
      end
      @file_handle=fh
      @parser = ::Warc::Parser.new
    end

    def each(offset=0,&block)
      @file_handle.seek(offset,::IO::SEEK_SET)
      loop do
        position = @file_handle.tell
        rec = self.read_record
        if rec
          rec.offset = position
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

    def record(offset=0)
      @file_handle.seek(offset,::IO::SEEK_SET)
      self.read_record
    end

    def close
      @file_handle.close
    end

    def read_record
      raise StandardError
    end

    def write_record(record)
      # Go to end of file
      @file_handle.seek(0,::IO::SEEK_END)
      expected_size = record.header.content_length + @file_handle.tell
      next_file_handle if (expected_size > @options[:max_filesize])
    end

    def size
      @file_handle.stat.size
    end
    
    private

    def next_file_handle
      @file_handle.close if @file_handle
      @index += 1
      path = @naming_proc.call(@name,@index)
      @file_handle = ::File.new(path + @ext,'a+')
    end
  end
end
