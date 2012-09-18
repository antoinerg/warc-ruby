module Warc
  class Record
    VERSION = "WARC/1.0"
    
    attr_reader :version, :header
    attr_accessor :content
 
    def initialize(header)
      @header = header
      @header.record = self
    end

    def dump_to(out)
      #    
      #      warc-file    = 1*warc-record
      #      warc-record  = header CRLF
      #                     block CRLF CRLF
      #      header       = version CRLF
      #                     warc-fields
      #      version      = "WARC/0.16" CRLF
      #      warc-fields  = *named-field CRLF
      #      block        = *OCTET
      #
      crfl = "\r\n"
      
      out.write(VERSION + crfl)
      out.write(self.header.to_s)
      out.write("\r\n")
      out.write(self.content + crfl*2)
    end
  end
end
