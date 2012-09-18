module Warc
  class Record
    attr_reader :version, :header
    attr_accessor :content
    def initialize(header)
      @header = header
    end

    def dump_to(out)
      out.write(self.header.to_s)
      out.write("\n")
      out.write(self.content)
    end
  end
end
