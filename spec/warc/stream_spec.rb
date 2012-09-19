require 'spec_helper.rb'

describe Warc::Stream do
  before(:each) do
    @rec = Warc::Record.new
    @rec.content = "asdf asdf"
    header=Warc::Record::Header.new({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z",
    })
    @rec.header = header
  end
  
  it "should dump record to file" do
    s = Warc::Stream::Plain.new('/tmp/test.warc')
    s.write_record(@rec)
    s.close
  end
  
  it "should dump gzipped to file" do
    s = Warc::Stream::Gzip.new('/tmp/test.warc.gz')
    s.write_record(@rec)
    s.close    
  end
end
