module Warc
  class Reader::Plain < Reader
    def initialize(path)
      super(path)
    end
    
    def parse_record(fh)
     # Find next item
     fh.each_line do |line| 
        break if line.chomp == "WARC/1.0"
     end
     
     # Prepare to read headers
     header = Warc::Header.new

     while m = /^(.*): (.*)/.match(fh.readline)
        header[m.captures[0]] = m.captures[1].chomp("\r")
     end
     
     record = Warc::Record.new(header)    
     record.content = fh.read(record.header.content_length)

     #@fh.seek(record.header["content-length"].to_i,IO::SEEK_CUR)
     return record
    end

  end
end