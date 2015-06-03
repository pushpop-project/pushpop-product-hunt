# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|

  s.name        = "pushpop-product-hunt"
  s.version     = '0.1'
  s.authors     = ["Joe Wegner"]
  s.email       = "joe@keen.io"
  s.homepage    = "https://github.com/pushpop-project/pushpop-product-hunt"
  s.summary     = "A Pushpop Plugin for triggering based on Product Hunt data"

  s.add_dependency "pushpop"
  s.add_dependency "hunting_season"
  s.add_dependency 'httparty'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

