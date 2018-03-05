# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "passfort/version"

Gem::Specification.new do |spec|
  spec.name = "passfort"
  spec.version = Passfort::VERSION
  spec.summary = "Client for the PassFort API"
  spec.authors = %w[GoCardless]
  spec.homepage = "https://github.com/gocardless/passfort"
  spec.email = %w[developers@gocardless.com]
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.0"
  spec.add_dependency "excon", "~> 0.60"

  spec.add_development_dependency "gc_ruboconfig", "~> 2.3"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.3"
  spec.add_development_dependency "webmock", "~> 3.3"
end
