require "uuid"
require "time"

module Warc
  class Record::Header < HeaderHash
    # WARC field names are case-insensitive
    # header["content-length"] == header["Content-Length"]
    
    attr_reader :record
    include ::ActiveModel::Validations
    validates_with ::Warc::Record::Validator

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
    
    REQUIRED_FIELDS = ["WARC-Record-ID","Content-Length","WARC-Date","WARC-Type"]
      
    def initialize(record,h={})
      @record=record
      super(h)
    end
    
    def content_length
    (self["content-length"] ||= self.record.content.length rescue 0).to_i
    end
    
    def date
      self["warc-date"] ||= Time.now.iso8601
    end

    def date=(d)
      self["warc-date"] = Time.parse(d).iso8601
    end

    def type
      self["warc-type"]
    end

    def record_id
      self["warc-record-id"] ||= sprintf("<urn:uuid:%s>",UUID.generate)
    end
    
    def block_digest
      self["warc-block-digest"] ||= compute_digest(self.record.content)
    end
    
    def compute_digest(content)
      "sha256:" + (Digest::SHA256.hexdigest(content))
    end
    
    def uri
      self["warc-target-uri"]
    end

    def to_s
      crfl="\r\n"
      str = String.new
      str << "WARC-Type: #{self.type}" + crfl
      str << "WARC-Record-ID: #{self.record_id}" + crfl
      str << "WARC-Date: #{self.date}" + crfl
      str << "Content-Length: #{self.content_length}" + crfl
      each do |k,v|
        str << "#{k}: #{v}#{crfl}" unless REQUIRED_FIELDS.map(&:downcase).include?(k)
      end
      return str
    end
  end
end
