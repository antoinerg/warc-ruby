require 'zlib'

module Warc
  class Stream::Gzip < Stream
    public_class_method :new
    def initialize(fh,options={},&block)
      @ext = ".warc.gz"
      super(fh,options,&block)
    end

    def read_record
      begin
        gz = ::Zlib::GzipReader.new(@file_handle)
        rec = self.parser.parse(gz)
        loop {gz.readline} # Make sure we read the whole gzip
      
      rescue EOFError # End of gzipped record
        @file_handle.pos -= gz.unused.length unless gz.unused.nil? # We move the cursor back if extra bytes were read
        return rec # We return the record
      
      rescue ::Zlib::Error => e # Raised when there's no more gzipped data to read
        return nil
      end
    end
    
    def write_record(record)
      super
      
      # Prepare gzip IO object
      gz = ::Zlib::GzipWriter.new(@file_handle)
      record.dump_to(gz)
      gz.finish # Need to close GzipWriter for it to write the gzip footer
    end
  end
end
