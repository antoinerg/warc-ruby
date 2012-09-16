require 'zlib'
module Warc
  class Reader::Gzip < Reader
    def initialize(path)
      super(path)
    end
    
    def parse_record(fh)
      begin
      zh = ::Zlib::GzipReader.new(fh)
    rescue ::Zlib::GzipFile::Error
      fh.seek(1,IO::SEEK_CUR)
      retry
    end
      version_line = zh.readline
      
      # Prepare to read headers
      header = Warc::Header.new
      
      while m = /^(.*): (.*)/.match(zh.readline)
         header[m.captures[0]] = m.captures[1].chomp("\r")
      end

      record = Warc::Record.new(header)    
      #record.content = zh.read(record.header.content_length)
      return record
    end
  end
end