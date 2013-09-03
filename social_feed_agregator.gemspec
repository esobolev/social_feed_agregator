# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_feed_agregator/version'

Gem::Specification.new do |spec|
  spec.name          = "social_feed_agregator"
  spec.version       = SocialFeedAgregator::VERSION
  spec.authors       = ["Eugene Sobolev"]
  spec.email         = ["eus@appfellas.co"]
  spec.description   = %q{Social Feed Agregator}
  spec.summary       = %q{Social Feed Agregator}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
