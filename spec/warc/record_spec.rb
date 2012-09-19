require 'spec_helper.rb'
require 'tempfile'

describe Warc::Record do
  before(:each) do
    @rec = Warc::Record.new
    @rec.content = "asdf"
    header=Warc::Record::Header.new({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z",
    })
    @rec.header = header
  end

  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end
  
  it "should compute content-length" do
    @rec.header.content_length.should eq(4)
  end

end
