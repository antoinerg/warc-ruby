module Warc
  class Record
    attr_reader :version, :header
    attr_accessor :content
                   
    def initialize(header)
      @header = header
    end
  end
end
