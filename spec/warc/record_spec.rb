require 'spec_helper.rb'

describe Warc::Record do
  before(:each) do
    @rec = Warc::Record.new
    @rec.content = "asdf"
    @rec.header.replace({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z"
    })
  end

  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end
  
  it "should compute content-length" do
    @rec.header.content_length.should eq(4)
  end
  
  it "should initialize from WEBrick::HTTPResponse" do
    record = Warc::Record.new()
  end
  
  it "should return a Net::HTTPResponse" do
    record = Warc.open_stream(fixture('ssd.warc.gz')).to_a[1]
    puts record.to_http.body
  end
end
