# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hntrendz/version'

Gem::Specification.new do |spec|
  spec.name          = "hntrendz"
  spec.version       = Hntrendz::VERSION
  spec.authors       = ["Sankaranarayanan Viswanathan"]
  spec.email         = ["rationalrevolt@gmail.com"]
  spec.summary       = %q{Capture trending information for Hacker News}
  spec.description   = %q{N/A}
  spec.homepage      = "https://github.com/rationalrevolt/hntrendz.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "hnposts", ">= 0.0.8"
  spec.add_dependency "sequel"
  spec.add_dependency "sinatra"
  spec.add_dependency "clockwork"
end
