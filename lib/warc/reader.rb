module Warc
  class Reader
   def initialize(path)
     # TODO check fh is file handle
     @path = path
   end
   
   def each_record(&block)
     begin
     fh = ::File.new(@path)
     while rec=next_record(fh)
       yield(rec)
     end
   rescue EOFError
     
   ensure
     fh.close
   end
   end
  
   def next_record(fh)
    seek_next(fh)

    # Prepare to read headers
    header = Warc::Header.new

    while m = /^(.*): (.*)/.match(fh.readline)
       header[m.captures[0]] = m.captures[1].chomp("\r")
    end
    
    record = Warc::Record.new(header)
    #@fh.seek(record.header["content-length"].to_i,IO::SEEK_CUR)
    return record
   end
   
   def seek_next(fh)
       # Read from current until we reache a new item
       fh.each_line do |line| 
         break if line.chomp == "WARC/1.0"
       end
   end
 end
end