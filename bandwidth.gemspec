lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bandwidth/version'

Gem::Specification.new do |spec|
  spec.name          = "bandwidth"
  spec.version       = Bandwidth::VERSION
  spec.authors       = ["Scott Barstow", "Phil Pirozhkov"]
  spec.description   = "Gem for integrating to Bandwidth's Telephony API"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/scottbarstow/ruby-bandwidth"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
