module Warc
  class Record
    VERSION = "WARC/1.0"

    attr_accessor :content, :offset
    attr_reader :header
    def initialize(h={},content=nil)
      @content=content
      case h
      when Hash
        @header = Header.new(self,h)
      when WEBrick::HTTPResponse
        @header = Header.new(self)
        @header["WARC-Type"] = "response"
        @header["WARC-Target-URI"] = h.request_uri.to_s
        @header["Content-Type"] = "application/http;msgtype=response"
        #@header["WARC-IP-Address"]
        body,crfl = String.new,"\r\n"
        body  << h.status_line
        h.header.each do |k,v|
          body << "#{k}: #{v}" + crfl
        end
        body  << crfl + h.body
        self.content = body
        self.header.block_digest
        @header["WARC-Payload-Digest"] = self.header.compute_digest(h.body)
      end
    end
    
    def to_http
      if @header["Content-Type"] == "application/http;msgtype=response"
        url = @header["WARC-Target-URI"]
        socket = Net::BufferedIO.new(content)
        r=Net::HTTPResponse.read_new(socket)
        r.reading_body(socket,true) {}
        return r
      end
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
