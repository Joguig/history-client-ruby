# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'history/version'

Gem::Specification.new do |spec|
  spec.name          = 'history-client'
  spec.version       = History::Client::VERSION
  spec.authors       = ['Jeff Day']
  spec.email         = ['jday@twitch.tv']

  spec.summary       = 'Client for history service'
  spec.description   = 'Client for history service'
  spec.homepage      = 'https://git-aws.internal.justin.tv/admin-services/history-client-ruby'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '0.9.0'
  spec.add_dependency 'faraday-detailed_logger', '2.1.0'
  spec.add_dependency 'faraday_middleware', '~> 0.9.1'
  spec.add_dependency 'oj', '>= 2.14.4'
  spec.add_dependency 'uuidtools', '2.1.5'

  spec.add_development_dependency 'bundler', '~> 1.16.1'
  spec.add_development_dependency 'rake', '~> 10.0'
end
