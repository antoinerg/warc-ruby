module Warc
  class Record
    VERSION = "WARC/1.0"
    
    attr_accessor :content
    attr_reader :header
 
    def initialize
    end
    
    def header=(h)
      @header=h
      h.record = self
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
      out.write(crfl)
      out.write(self.content + crfl*2)
    end
  end
end
