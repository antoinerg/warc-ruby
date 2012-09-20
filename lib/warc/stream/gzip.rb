require 'zlib'

module Warc
  class Stream::Gzip < Stream
    def initialize(fh)
      super(fh)
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
      # Go to end of file
      @file_handle.seek(0,::IO::SEEK_END)
      
      # Prepare gzip IO object
      gz = ::Zlib::GzipWriter.new(@file_handle)
      record.dump_to(gz)
      gz.finish # Needed to close for gzip to write the gzip footer
    end
  end
end
