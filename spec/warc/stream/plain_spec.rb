require 'spec_helper.rb'

describe Warc::Stream::Plain do
  context "single entry of an uncompressed file" do
    before(:each) do
      @warc=Warc.open_stream(fixture('criterion.warc'))
      @record = @warc.first
    end

    it "should parse all headers" do
      @record.header.length.should eq(7)
    end

    it "should return the headers as an hash" do
      @record.header.should eq({
        "warc-type" => "warcinfo",
        "content-type" => "application/warc-fields",
        "warc-date" => "2012-09-13T22:53:20Z",
        "warc-record-id" => "<urn:uuid:CF5083F4-FEB1-4C63-B3CB-B450AB609875>",
        "warc-filename" => "criterion.warc",
        "warc-block-digest" => "sha1:XGSXIX3L7RQGXFU6XJ32NCHXCKN6BBMK",
        "content-length" => "258"
      })
    end

    it "should read the content" do
      @record.content.length.should eq @record.header.content_length
    end
  end

  context "multiples entries" do
    before(:each) do
      @warc=Warc.open_stream(fixture('frg.warc'))
    end
    
    it "should find all record" do
      @warc.count.should eq 56
    end

  end
end
