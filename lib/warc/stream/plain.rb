module Warc
  class Stream::Plain < Stream
    def initialize(fh)
      super(fh)
    end
    
    def read_record
	begin 
      		self.parser.parse(self.file_handle)
	rescue EOFError
		return nil
	end
    end

  end
end
