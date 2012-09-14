require 'spec_helper.rb'

describe Warc::Record do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
    @rec = @warc.first
  end
  
  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end
end