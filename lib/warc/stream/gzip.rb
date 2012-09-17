require 'zlib'
module Warc
  class Stream::Gzip < Stream
    def initialize(fh)
      super(fh)
    end
    
    def read_record
      begin
	gz = ::Zlib::GzipReader.new(self.file_handle)
        rec = self.parser.parse(gz)
	loop {gz.readline}
      rescue EOFError
        @file_handle.pos -= gz.unused.length unless gz.unused.nil?
	return rec
      rescue ::Zlib::Error
        return nil
      end
    end
end
end
