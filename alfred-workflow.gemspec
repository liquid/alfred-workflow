# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alfred/workflow/version'

Gem::Specification.new do |spec|
  spec.name          = "alfred-workflow"
  spec.version       = Alfred::Workflow::VERSION
  spec.authors       = ['Zhao Cai', 'Attila Gyorffy']
  spec.email         = ["attila@attilagyorffy.com"]
  spec.description   = 'alfred-workflow is a ruby Gem helper for building [Alfred](http://www.alfredapp.com) workflow.'
  spec.email         = 'caizhaoff@gmail.com'
  spec.summary       = 'alfred-workflow is a ruby Gem helper for building [Alfred](http://www.alfredapp.com) workflow.'
  spec.homepage      = "http://zhaocai.github.com/alfred2-ruby-template/"
  spec.license       = "GPL-3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'plist', '>= 3.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', ">= 2.13"
  spec.add_development_dependency 'facets', '>= 2.9.0'
  spec.add_development_dependency 'guard', '~> 1.7.0'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'growl'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'nokogiri'
end
