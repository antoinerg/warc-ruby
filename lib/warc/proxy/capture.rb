require 'webrick'
require 'webrick/httpproxy'

module Warc::Proxy
  class Capture
    def self.start(warc)

      Thread.abort_on_exception = true

      warc_stream = Warc::Stream::Gzip.new(warc)
      q=Queue.new

      s=WEBrick::HTTPProxyServer.new({:Port=>9292,
        :ProxyContentHandler => Proc.new{|req,res| q << [req,res]},
        :AccessLog => [["/dev/zero",WEBrick::AccessLog::COMMON_LOG_FORMAT]]
      })

      t=Thread.new do
        loop do
          req,res = q.pop
          unless res.status == 304
            record = Warc::Record.new(res)
            warc_stream.write_record(record)
            
            puts "Saved block #{record.header.record_id} to archive"
          end
        end
      end
      
      # Shutdown functionality
      trap("INT"){s.shutdown;t.exit}
      s.start
      t.join
    end
  end
end