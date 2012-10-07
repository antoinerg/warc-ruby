module Warc
  class Stream::Plain < Stream
    public_class_method :new
    
    def initialize(fh,options={},&block)
      @ext = '.warc'
      super(fh,options,&block)
    end

    def read_record
      begin
        self.parser.parse(@file_handle)
      rescue EOFError # No more records
        return nil
      end
    end
    
    def write_record(record)
      super
      record.dump_to(@file_handle)
    end
  end
end
