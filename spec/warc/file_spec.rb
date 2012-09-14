require 'spec_helper.rb'

describe Warc::File do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
  end
end

describe Warc::Reader do
  context "single entry" do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
    @record = @warc.first
  end
  
  it "should parse all headers" do
    @record.header.length.should eq(7)
  end
  
  it "should read key value from header" do
     @record.header["content-length"].should eq("258")
  end
  end
  
  context "multiples entries" do
    before(:each) do
      @warc=Warc::File.new(fixture('frg.warc'))
    end
    
    it "should find all record" do
      @warc.count.should eq 56
    end
    
  end  
end