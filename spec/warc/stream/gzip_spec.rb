require 'spec_helper.rb'

describe Warc::Stream::Gzip do
  context "compressed file single entry" do
    before(:each) do
      @warc=Warc.open_stream(fixture('criterion.warc.gz'))
      @record = @warc.first
    end

    it "should read the content" do
      @record.content.length.should eq @record.header.content_length
    end

    it "should parse all headers" do
      @record.header.length.should eq(7)
    end

    it "should return the headers as an hash" do
      @record.header.should eq({
        "warc-type" => "warcinfo",
        "content-type" => "application/warc-fields",
        "warc-date" => "2012-09-13T22:52:52Z",
        "warc-record-id" => "<urn:uuid:671787C3-3C00-4256-8C5C-386A4D8F7468>",
        "warc-filename" => "criterion.warc.gz",
        "warc-block-digest" => "sha1:OX3R5RVY4LFQ6WIPTDCLTY3ABKWLXUBU",
        "content-length" => "234"
      })
    end

  end

  context "compressed file mutliple entries" do
    before(:each) do
      @warc=Warc.open_stream(fixture('frg.warc.gz'))
    end

    it "should find all record" do
      @warc.count.should eq 56
    end
  end
end
