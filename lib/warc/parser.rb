module Warc
  class Parser
    def parse(stream)
      # Find next item
      loop do
        version_line = stream.readline
        break if version_line.chomp("\r\n") == "WARC/1.0"
      end

      # Prepare to read headers
      rec = Warc::Record.new

      while m = /^(.*): (.*)/.match(stream.readline)
        rec.header[m.captures[0]] = m.captures[1].chomp("\r")
      end

      #puts header

      rec.content = stream.read(rec.header.content_length)

      #@fh.seek(record.header["content-length"].to_i,IO::SEEK_CUR)
      return rec
    end
  end
end
