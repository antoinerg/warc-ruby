# -*- encoding: utf-8 -*-
require File.expand_path('../lib/warc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["antoine"]
  gem.email         = ["roygobeil.antoine@gmail.com"]
  #gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{warc is a pure ruby implementation of Web ARChive file reader and writer}
  gem.homepage      = ""

  gem.license = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "warc"
  gem.require_paths = ["lib"]
  gem.version       = Warc::VERSION
  
  gem.add_dependency("uuid")
  gem.add_dependency("activemodel")
  gem.add_dependency("rack")
  gem.add_dependency("thor")
  gem.add_dependency("rack-contrib")
  gem.add_dependency("sinatra")
  gem.add_dependency("thin")
end