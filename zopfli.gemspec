# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zopfli/version'

Gem::Specification.new do |spec|
  spec.name          = "zopfli"
  spec.version       = Zopfli::VERSION
  spec.authors       = ["miyucy"]
  spec.email         = ["fistfvck@gmail.com"]
  spec.description   = "zopfli"
  spec.summary       = "zopfli"
  spec.homepage      = "http://github.com/miyucy/zopfli"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.test_files    = `git ls-files -z -- test`.split("\x0")
  spec.files         = `git ls-files -z`.split("\x0")
  spec.files        -= spec.test_files
  spec.files        -= ['vendor/zopfli']
  spec.files        += Dir['vendor/zopfli/src/zopfli/**/*']
  spec.files        += ['vendor/zopfli/COPYING']

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/extconf.rb"]
end
