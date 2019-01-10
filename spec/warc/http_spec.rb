require 'spec_helper.rb'

describe Warc::HTTP do

  it "should be able to return a HTTPResponse object from a warc record" do
    record = ::Warc.open_stream(fixture('criterion.warc.gz')).to_a[2]
    record.to_http.class.should eq (Net::HTTPOK)
  end

end
