# -*- coding: utf-8; mode: ruby; -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mt/rebuild/version'

Gem::Specification.new do |spec|
  spec.name          = "mt-rebuild"
  spec.version       = Mt::Rebuild::VERSION
  spec.authors       = ["Shigeaki Matsumura"]
  spec.email         = ["matsu911@gmail.com"]
  spec.summary       = %q{Command line tool for rebuilding MovableType pages on a remote server.}
  spec.description   = %q{Command line tool for rebuilding MovableType pages on a remote server.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('cri', '~> 2.6')
  spec.add_dependency('faraday', '~> 0.9')

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
