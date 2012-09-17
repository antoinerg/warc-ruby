module Warc
  class Parser
   def parse(stream)
     # Find next item
     loop do
        version_line = stream.readline 
        break if version_line.chomp("\r\n") == "WARC/1.0"
     end
     
     # Prepare to read headers
     header = Warc::Record::Header.new

     while m = /^(.*): (.*)/.match(stream.readline)
        header[m.captures[0]] = m.captures[1].chomp("\r")
     end

     #puts header
     
     record = Warc::Record.new(header)    
     record.content = stream.read(record.header.content_length)

     #@fh.seek(record.header["content-length"].to_i,IO::SEEK_CUR)
     return record
   end
 end
end
