require 'spec_helper.rb'

describe Warc::Record::Header do
  context "when instansiated with some value" do
    before(:each) do
      @header=Warc::Record.new({
        "WARC-Type"=> "response",
        "WARC-Record-ID" => "<record-1>",
        "WARC-Date" => "2000-01-02T03:04:05Z",
        "Content-Length" => "10"
      }).header
    end
    
    subject {@header}

    its(:type) { should eq "response"}
    it "should have attributes for mandatory fields" do
      @header.type.should eq "response"
      @header.record_id.should eq "<record-1>"
      @header.date.should eq "2000-01-02T03:04:05Z"
      @header.content_length.should eq 10
    end

    it "should be case-insensitive to field names" do
      ["WARC-Type", "warc-type", "WARC-TYPE"].each do |key|
        @header[key].should eq "response"
      end
    end

    context "when warc-content-length empty" do
      before {@header.delete("content-length")}
      it "should assume a content-lenght of 0" do
        @header.content_length.should eq 0
      end
    end
  end

  context "" do
    before(:each) do
      @warc = Warc.open_stream(fixture('arg.warc'))
      @record = @warc.first
    end
  end
end