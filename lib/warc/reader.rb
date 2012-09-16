module Warc
  class Reader
   def initialize(path)
     @path = path
   end
   
   def self.parse(path)
     if self.gzip?(path)
      Reader::Gzip.new(path)
     else
      Reader::Plain.new(path)
     end
   end
   
   def file_handle
     ::File.new(@path,'r')
   end
   
   def gzip?
     return Pathname.new(@path).extname == '.gz'
   end
   
   def self.gzip?(path)
     return Pathname.new(path).extname == '.gz'     
   end
   
   def each_record(&block)
     fh = file_handle
     while rec=parse_record(fh)
       yield(rec)
     end
     fh.close
   end
 end
end