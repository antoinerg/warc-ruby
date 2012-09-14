require "warc/validator"

module Warc
  class Record
    attr_reader :version, :header
    attr_accessor :content
                   
    def initialize(header)
      @header = Header.new(header)
    end
  end
end