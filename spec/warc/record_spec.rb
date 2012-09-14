require 'spec_helper.rb'

describe Warc::Record do
  it "should check for warc-record-id field" do
    rec = Warc::Record.new({"content-length" => "254"})
    rec.valid?
  end
  
  it "should assume a content-lenght of 0 if unspecified" do
    rec = Warc::Record.new({"WARC-Type" => "Resouce"})
    rec.header.content_length.should eq 0
  end
end