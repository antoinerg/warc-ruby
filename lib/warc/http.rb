require 'net/http'

module Warc
  class HTTP
    def self.get(uri)
      url = URI(uri)
      net_res = Net::HTTP.get_response(url)
      
      record = ::Warc::Record.new
      record.header["warc-type"] = "response"
      record.header["warc-date"] = net_res.to_hash["date"][0]
      record.header["warc-target-uri"] = url.to_s
      
      headers = String.new
      headers << "HTTP/#{net_res.http_version} #{net_res.code} #{net_res.message}\r\n"
      net_res.to_hash.each {|key,value| headers << "#{key}: #{value[0].to_s}\r\n"}
      
      record.content = "#{headers}#{net_res.body}"
      return record,net_res
    end
    
    def self.archive(uri,stream)
      stream = case stream
      when ::Warc::Stream 
        stream
      when String
        ::Warc::Stream::Gzip.new(stream)
      end
      
      record,response = self.get(uri)
      stream.write_record(record)
      return response
    end
      
  end
end