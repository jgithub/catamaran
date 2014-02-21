require File.dirname(__FILE__) + "/lib/catamaran/version"

Gem::Specification.new do |s|
  s.name             = "catamaran"
  s.version          = Catamaran::VERSION
  s.authors          = ["Jeano"]
  s.email            = ["catamaran@jeano.net"]
  s.summary          = "Catamaran Logger"
  s.description      = "A logging utility"
  s.homepage         = "http://github.com/jgithub/catamaran"
  s.files            = `git ls-files`.split("\n")
  s.licenses         = ['MIT']

  s.add_dependency 'rake'
  s.add_development_dependency 'rspec'
end


