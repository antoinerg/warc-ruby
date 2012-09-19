require 'spec_helper.rb'

describe Warc::Record do
  before(:each) do
    @rec = Warc::Record.new
    @rec.content = "asdfa sdf asdfasdf <asdasdf <asdf asdfasdf"
    header=Warc::Record::Header.new({
      "WARC-Type"=> "response",
      "WARC-Date" => "2000-01-02T03:04:05Z",
    })
    @rec.header = header
    header.record = @rec
  end

  it "should have a header" do
    @rec.respond_to?(:header).should eq true
  end

  it "should dump record to IO" do
    $stdout.write("\n")
    @rec.dump_to($stdout)
  end
end
