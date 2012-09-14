require 'spec_helper.rb'

describe Warc::File do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
  end
end

describe Warc::Parser do
  context "single entry" do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
  end
  
  it "should read all headers" do
    @warc.parser.next_record.header.length.should eq(7)
  end
  
  it "should read key value from header" do
     @warc.parser.next_record.header["content-length"].should eq("258")
  end
  end
  
  context "multiples entries" do
    before(:each) do
      @warc=Warc::File.new(fixture('fiscalitefrg.warc'))
    end
    
    it "should iterate through record" do
      total = 0
      @warc.each_record do |p|
        total = total+1
      end
      total.should eq (112)
    end
    
  end  
end