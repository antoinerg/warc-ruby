module Warc
  class Parser
   def initialize(warc_file)
     # TODO check fh is file handle
     @fh = warc_file.file_handle
   end
   
   def next_record
    begin
    # Get version
    version_line = @fh.readline
    
    # Prepare to read headers
    header = Warc::Record::Header.new

    while m = /^(.*): (.*)/.match(@fh.readline)
       header[m.captures[0]] = m.captures[1].chomp("\r")
    end
    
    record = Warc::Record.new(version_line,header)
    @fh.seek(record.header["content-length"].to_i,IO::SEEK_CUR)
    return record
    rescue IO::EOFError
      return false
    end
   end 
 end
end