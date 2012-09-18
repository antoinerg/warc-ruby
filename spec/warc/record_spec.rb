require 'spec_helper.rb'

describe Warc::Record do
  before(:each) do
    header=Warc::Record::Header.new({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z",
      "Content-Length" => "10"
    })
    @rec = Warc::Record.new(header)
    @rec.content = "asdfa sdf asdfasdf <asdasdf <asdf asdfasdf"
  end

  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end

  it "should dump record to IO" do
    @rec.dump_to($stdout)
  end
end
