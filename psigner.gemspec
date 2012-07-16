# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "psigner"
  s.version     = Psigner::VERSION
  s.authors     = ["James Turnbull"]
  s.email       = ["james@lovedthanlost.net"]
  s.homepage    = ""
  s.summary     = %q{A simple Sinatra app to sign Puppet certificate requests.}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "sinatra"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
end
