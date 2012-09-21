# -*- encoding: utf-8 -*-
require File.expand_path('../lib/metarake/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maciej Pasternacki"]
  gem.email         = ["maciej@pasternacki.net"]
  gem.description   = "A Rake extension to build multiple separate projects, published outside the repository"
  gem.summary       = "Rake extension to manage multiple builds"
  gem.homepage      = "https"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "metarake"
  gem.require_paths = ["lib"]
  gem.version       = MetaRake::VERSION

  gem.add_dependency "rake", ">= 0.9.2"

  gem.add_development_dependency "cucumber"
  gem.add_development_dependency 'rspec-expectations'
  gem.add_development_dependency "mixlib-shellout"
end
