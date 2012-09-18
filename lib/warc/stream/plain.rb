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
    
    def write_record(record)
      record.dump_to(@file_handle)
    end
  end
end
