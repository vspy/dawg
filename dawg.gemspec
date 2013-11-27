# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dawg/version"

Gem::Specification.new do |s|
  s.name        = "dawg"
  s.version     = Dawg::VERSION
  s.authors     = ["Victor Bilyk"]
  s.email       = ["victorbilyk@gmail.com"]
  s.homepage    = "http://github.com/vspy/dawg"
  s.summary     = %q{DAWG}
  s.description = %q{Directed Acyclic Word Graph}

  s.rubyforge_project = "dawg"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extensions    = ['ext/dawg/extconf.rb']
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }+['dawg']
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rake-compiler"
  # s.add_runtime_dependency "rest-client"
end
