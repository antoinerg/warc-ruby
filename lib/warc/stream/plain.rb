module Warc
  class Stream::Plain < Stream
    def initialize(fh)
      super(fh)
    end

    def read_record
      begin
        self.parser.parse(@file_handle)
      rescue EOFError # No more records
        return nil
      end
    end

  end
end
