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
        "WARC-Type" => "warcinfo",
        "Content-Type" => "application/warc-fields",
        "WARC-Date" => "2012-09-13T22:53:20Z",
        "WARC-Record-ID" => "<urn:uuid:CF5083F4-FEB1-4C63-B3CB-B450AB609875>",
        "WARC-Filename" => "criterion.warc",
        "WARC-Block-Digest" => "sha1:XGSXIX3L7RQGXFU6XJ32NCHXCKN6BBMK",
        "Content-Length" => "258"
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
