require 'warc'
require 'rspec/its'

def fixture(path)
  File.expand_path(File.join(File.dirname(__FILE__),'fixtures',path))
end

def read_fixture(path)
  File.read(fixture(path))
end

SAMPLES = {
  "http://www.imdb.com/" => "http_imdb"
}

unless ENV['LIVE_TEST']
  begin
    require 'fakeweb'

    FakeWeb.allow_net_connect = false
    SAMPLES.each do |url,path|
      FakeWeb.register_uri(:get,url,:response => read_fixture(path))
    end
  rescue LoadError
    puts "Could not load FakeWeb, these tests will hit IMDB.com"
    puts "You can run `gem install fakeweb` to stub out the responses."
  end
end
