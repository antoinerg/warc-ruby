require 'spec_helper.rb'

describe Warc::Record do
  before(:each) do
    @warc_header = Warc::Record::Header.new({:content_length => "200"})
    @rec=Warc::Record.new(@warc_header)
  end
  
  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end
end
