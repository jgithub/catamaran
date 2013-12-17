require File.dirname(__FILE__) + "/lib/catamaran/version"

Gem::Specification.new do |s|
  s.name             = "catamaran"
  s.version          = Catamaran::VERSION
  s.authors          = ["Jeano"]
  s.email            = ["catamaran@jeano.net"]
  s.summary          = "Catamaran Logger"
  s.description      = "Another logging tool"
  s.homepage         = "http://github.com/jgithub/catamaran"
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_development_dependency "rspec", "~> 2.0"
end


