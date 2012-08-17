# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crx/version"

Gem::Specification.new do |s|
  s.name        = "crx"
  s.version     = Crx::VERSION
  s.authors     = ["lewy"]
  s.email       = ["lewy313@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{easily generate chrome extensions}
  s.description = %q{easily generate chrome extensions}

  s.rubyforge_project = "crx"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "libnotify"
  s.add_development_dependency "guard-rspec"

  s.add_runtime_dependency "thor"
end
