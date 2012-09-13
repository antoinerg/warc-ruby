require 'IO'

module Warc
  class Record
  
    DEFINED_FIELDS = {
                   "WARC-Type",
                   "WARC-Record-ID",
                   "WARC-Date",
                   "Content-Length",
                   "Content-Type",
                   "ARC-Concurrent-To",
                   "WARC-Block-Digest",
                   "WARC-Payload-Digest",
                   "WARC-IP-Address",
                   "WARC-Refers-To",
                   "WARC-Target-URI",
                   "WARC-Truncated"
                   "WARC-Warcinfo-ID",
                   "WARC-Filename", #warcinfo only
                   "WARC-Profile", #revisit only
                   | WARC-Identified-Payload-Type
                   | WARC-Segment-Origin-ID       ; continuation only
                   | WARC-Segment-Number
                   | WARC-Segment-Total-Length    ; continuation only
    def initialize(header,content)
      @header = header
      @content = content
    end

    def header
      
    end
  end
end