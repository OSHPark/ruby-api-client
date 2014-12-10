# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oshpark/version'

Gem::Specification.new do |spec|
  spec.name          = "oshpark"
  spec.version       = Oshpark::VERSION
  spec.authors       = ["James Harton", "Henry Maddocks"]
  spec.email         = ["james@resistor.io", "henry@resistor.io"]
  spec.summary       = %q{API and command line client for oshpark.com}
  spec.description   = %q{API and command line client for PCB fabrication via oshpark.com}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"

  %w| cucumber rspec-core rspec-mocks rspec-its guard-rspec guard-cucumber guard-bundler pry rake byebug|.each do |gem|
    spec.add_development_dependency gem
  end

  spec.add_dependency 'micro_token'
  spec.add_dependency 'thor'
end
