require 'spec_helper.rb'

describe Warc::HTTP do
  it "should get both a record and a Net::HTTP" do
    record,response=Warc::HTTP.get("http://www.imdb.com/")
    record.content.length.should eq(record.header.content_length)
    response.class.should eq(Net::HTTPOK)
  end
  
  it "should write to archive" do
    Warc::HTTP.archive("http://www.imdb.com/","/tmp/imdb.warc.gz")
  end
  
end