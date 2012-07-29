# -*- encoding: utf-8 -*-

require File.expand_path('../lib/java/superclass/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "java_superclass"
  gem.version       = Java::Superclass::VERSION
  gem.summary       = %q{Useful utilities supporting Java class inheritance in JRuby}
  gem.description   = %q{Useful utilities supporting Java class inheritance in JRuby. Enable overriding plain Java methods with Ruby naming conventions.}
  gem.license       = "MIT"
  gem.authors       = ["Szymon Wrozynski"]
  gem.email         = "szymon@wrozynski.com"
  gem.homepage      = "https://rubygems.org/gems/java_superclass"

  gem.platform      = 'java'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
end
