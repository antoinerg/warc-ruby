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
        @header["WARC-Target-URI"] = h.request_uri
        @header["Content-Type"] = "application/http;msgtype=response"
        body,crfl = String.new,"\r\n"
        body  << h.status_line
        h.header.each do |k,v|
          body << "#{k}: #{v}" + crfl
        end
        body  << crfl + h.body
        self.content = body
      end

    end

    def to_http
      if @header["Content-Type"] == "application/http;msgtype=response" || "application/http; msgtype=response"
        url = @header["warc-target-uri"]
        socket = Net::BufferedIO.new(content)
        r=Net::HTTPResponse.read_new(socket)
        r.reading_body(socket,true) {}
        
        # Ugly hack to deal with gzipped response. Note that net library in ruby 2.0 will do that automatically  
        if r["content-encoding"] == "gzip" && r["content-type"].include?("text/html")
          inflater = ::Zlib::Inflate.new(32 + Zlib::MAX_WBITS)
          buf = inflater.inflate(r.body)
          inflater.finish
          inflater.close
          r.body=buf
        end
        return r
      else
        return nil
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
