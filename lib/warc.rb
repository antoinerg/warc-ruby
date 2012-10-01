require "warc/version"
require "warc/cli"

# Updated NET library (will be included in 2.0)
#require "warc/ext/net_http"

# http tools
require "warc/proxy"
require "warc/http"

# Stream
require "warc/stream"
require "warc/stream/plain"
require "warc/stream/gzip"

# Record
require "warc/record"
require "warc/record/header_hash"
require "warc/record/validator"
require "warc/record/header"

# Parser
require "warc/parser"

# Exception
require "warc/exceptions"

module Warc

end
