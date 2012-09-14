require "warc/validator"

module Warc
  class Record
    include ::ActiveModel::Validations
    validates_with Validator
    
    attr_reader :version, :header
    # Set of field names defined in the spec
    NAMED_FIELDS = [
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
                   "WARC-Truncated",
                   "WARC-Warcinfo-ID",
                   "WARC-Filename", #warcinfo only
                   "WARC-Profile", #revisit only
                   "WARC-Identified-Payload-Type",
                   "WARC-Segment-Origin-ID",       # continuation only
                   "WARC-Segment-Number",
                   "WARC-Segment-Total-Length" #continuation only
                 ]
                   
    def initialize(header,content=nil)
      @header = Header.new(header)
      @content = content
    end
    
    def content
    
    end
    
  end
end