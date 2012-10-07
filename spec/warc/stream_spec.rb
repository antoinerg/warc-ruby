require 'spec_helper.rb'
require 'fileutils'

describe Warc::Stream do
  before(:each) do
    @rec = Warc::Record.new
    @rec.content = "asdf asdf"
    @rec.header.replace({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z",
    })
    header = @rec.header
  end
  
  it "can't be initialized" do
    #s = Warc::Stream.new
  end
  
  it "should save to multiple files" do
    s=Warc::Stream::Plain.new('/tmp/test',:max_filesize => 10*10**6)
    100.times do
      r = Warc::Record.new
      r.content = "0" * (10**6)
      r.header.replace({"WARC-Type"=> "response","WARC-Date" => "2000-01-02T03:04:05Z"})  
      s.write_record(r)
    end
    ::File.exists?('/tmp/test.000010.warc').should eq(true)
    FileUtils.rm Dir.glob('/tmp/test.*.warc')
  end
  
  it "should dump record to file" do
    s = Warc::Stream::Plain.new('/tmp/test.plain')
    s.write_record(@rec)
    s.close
  end
  
  it "should dump gzipped to file" do
    s = Warc::Stream::Gzip.new('/tmp/test.gzip')
    s.write_record(@rec)
    s.close    
  end
  
  it "should find record" do
    stream = ::Warc.open_stream(fixture('arg.warc'))
    uri = "http://antoineroygobeil.com/"
    record = stream.detect do |rec|
      rec.header["warc-target-uri"] == uri && rec.header["warc-type"] == "response"
    end
  end
  
  it "should read record at given offset" do
    stream = ::Warc.open_stream(fixture('arg.warc'))
    stream.record(8287).header.record_id.should eq("<urn:uuid:5D799C11-D46C-4AC8-B598-5DC9F4205C6E>")
  end
end
