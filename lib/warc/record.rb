require "active_support/hash_with_indifferent_access"

module Warc
  class Record  
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
                   
    def initialize(version,header,content=nil)
      @version = version
      @header = header
      @content = content
    end
    
    def content
    
    end
    
  end
  
  class Record::Header < HashWithIndifferentAccess
    # Field names are case-insensitive
    # @record.header["content-length"] == @record.header["Content-Length"]
    
    # Following was taken from:
    # http://stackoverflow.com/questions/2030336/how-do-i-create-a-hash-in-ruby-that-compares-strings-ignoring-case
    
    # This method shouldn't need an override, but my tests say otherwise.
    def [](key)
      super convert_key(key)
    end

    protected

    def convert_key(key)
      key.respond_to?(:downcase) ? key.downcase : key
    end  
  end
end