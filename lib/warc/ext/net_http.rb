require 'net/http'
require 'net/https'
require 'stringio'

module Net
  class BufferedIO
    def initialize(io,debug_output = nil)
      @read_timeout = 60
      @rbuf = ''
      @debug_output = debug_output

      @io = case io
      when Socket, OpenSSL::SSL::SSLSocket, StringIO, IO
        io
      when String
        if !io.include?("\0") && File.exists?(io) && !File.directory?(io)
          File.open(io, "r")
        else
          StringIO.new(io)
        end
      end
      raise "Unable to create fake socket from #{io}" unless @io
    end
  end
  
  class HTTP
    class << self
      def socket_type_with_warc
        FakeWeb::StubSocket
      end
      alias_method :socket_type, :socket_type_with_warc
    end
  end
end

module Warc
  class StubSocket #:nodoc:

    def initialize(*args)
    end

    def closed?
      @closed ||= true
    end

    def readuntil(*args)
    end

  end
end
