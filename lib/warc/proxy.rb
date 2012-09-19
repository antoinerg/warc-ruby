require 'rack'
module Warc
  class Proxy < ::Rack::Server
    def call(env)
      [200,{},["Hello"]]
    end
    
    def start
      trap(:INT) { exit }
      super
    end
  end
end