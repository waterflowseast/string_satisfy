# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'string_satisfy/version'

Gem::Specification.new do |spec|
  spec.name          = "string_satisfy"
  spec.version       = StringSatisfy::VERSION
  spec.authors       = ["Eric Huang"]
  spec.email         = ["WaterFlowsEast@gmail.com"]
  spec.summary       = %q{Check whether string pattern can be satisfied with given strings}
  spec.description   = %q{create a string pattern with &(represents AND) and |(represents OR), check whether it can be satisfied with given strings}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 4.7.5"
end
