# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'degzipper/version'

Gem::Specification.new do |spec|
  spec.name          = "degzipper"
  spec.version       = Degzipper::VERSION
  spec.authors       = ["Andrew Hammond", "Bob Breznak"]
  spec.email         = ["andrew@evertrue.com"]
  spec.description   = %q{Rack middleware to inflate incoming Gzip data from HTTP requests.}
  spec.summary       = %q{Rack middleware to inflate incoming Gzip data from HTTP requests.}
  spec.homepage      = "http://github.com/andrhamm/degzipper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
