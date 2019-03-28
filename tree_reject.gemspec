# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tree_reject/version'

Gem::Specification.new do |spec|
  spec.name          = 'tree_reject'
  spec.version       = TreeReject::VERSION
  spec.authors       = ['Salsify, Inc']
  spec.email         = ['engineering@salsify.com']

  spec.summary       = 'Remove deeply nested keys from hash.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/salsify/tree_reject'

  spec.license       = 'MIT'


  # Set 'allowed_push_post' to control where this gem can be published.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'

  spec.add_development_dependency 'salsify_rubocop', '~> 0.60.0'

end
