require "active_support/hash_with_indifferent_access"
require "active_model"
module Warc
class Header < HashWithIndifferentAccess
  # Field names are case-insensitive
  # @record.header["content-length"] == @record.header["Content-Length"]
  
  # Following was taken from:
  # http://stackoverflow.com/questions/2030336/how-do-i-create-a-hash-in-ruby-that-compares-strings-ignoring-case
  
  # This method shouldn't need an override, but my tests say otherwise.
  def [](key)
    super convert_key(key)
  end
  
  def content_length
    self["content-length"].to_i || 0
  end
  
  def date
    self["warc-date"]
  end    
  
  def date=(d)
    self["WARC-Date"] = Time.parse(d).iso8601
  end
  
  protected

  def convert_key(key)
    key.respond_to?(:downcase) ? key.downcase : key
  end
end
end