module Warc
  class HTTP
    def self.get(uri)
      url = URI(uri)
      net_res = Net::HTTP.get_response(url)

      record = ::Warc::Record.new
      record.header["WARC-Type"] = "response"
      record.header.date = net_res.to_hash["date"][0]
      record.header["WARC-Target-URI"] = url.to_s
      record.header["Content-Type"] = "application/http;msgtype=response"

      headers = String.new
      headers << "HTTP/#{net_res.http_version} #{net_res.code} #{net_res.message}\r\n"
      net_res.to_hash.each {|key,value| headers << "#{key}: #{value[0].to_s}\r\n"}

      record.content = "#{headers}\r\n#{net_res.body}"
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