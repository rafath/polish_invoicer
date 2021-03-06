# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polish_invoicer/version'

Gem::Specification.new do |spec|
  spec.name          = "polish_invoicer"
  spec.version       = PolishInvoicer::VERSION
  spec.authors       = ["Piotr Macuk"]
  spec.email         = ["piotr@macuk.pl"]
  spec.description   = %q{Creates polish invoices and proforms as HTML or PDF files}
  spec.summary       = %q{Creates polish invoices and proforms as HTML or PDF files}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"

  spec.add_dependency 'slim2pdf', '~> 0.0.3'
end
