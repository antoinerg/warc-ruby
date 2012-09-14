require 'zlib'

module Warc
  class Reader
   def initialize(path)
     @path = path
   end
   
   def file_handle
     if gzip?
       ::Zlib::GzipReader.new(::File.new(@path,'r'))
     else
       ::File.new(@path,'r')
     end
   end
   
   def gzip?
     return Pathname.new(@path).extname == '.gz'
   end
   
   def each_record(&block)
     begin
     fh = file_handle
     while rec=next_record(fh)
       yield(rec)
     end
   rescue EOFError
     
   rescue Exception => e
     puts e.message
     puts e.backtrace
   ensure
     fh.close
   end
   end
   
   def next_record(fh)
    seek_next(fh)
    offset = IO::SEEK_CUR
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
   
   def seek_next(fh)
       # Read from current until we reache a new item
       fh.each_line do |line| 
         break if line.chomp == "WARC/1.0"
       end
   end
 end
end