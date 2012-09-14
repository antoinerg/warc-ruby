require "active_support/hash_with_indifferent_access"
require "active_model"
module Warc
class Header < HashWithIndifferentAccess
  include ::ActiveModel::Validations
  validates_with Validator
  
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

  def content_length
    self["content-length"].to_i || 0
  end
  
  def date
    self["warc-date"]
  end    
  
  def date=(d)
    self["warc-date"] = Time.parse(d).iso8601
  end
  
  def type
    self["warc-type"]
  end
  
  def record_id
    self["warc-record-id"]
  end
  
  def to_s
    str = String.new
    each do |k,v|
      str << "#{k}: #{v}\r\n"
    end
    return str
  end

  # WARC field names are case-insensitive
  # header["content-length"] == header["Content-Length"]
  
  # To achieve this behavior, the following is used
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