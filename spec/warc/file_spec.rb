require 'spec_helper.rb'

describe Warc::File do
  before(:each) do
    @warc=Warc::File.new(fixture('criterion.warc'))
  end
end