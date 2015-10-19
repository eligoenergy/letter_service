# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letter_service/version'

Gem::Specification.new do |spec|
  spec.name          = 'letter_service'
  spec.version       = LetterService::VERSION
  spec.authors       = ['Eric Nelson']
  spec.email         = ['enelson@eligoenergy.com']

  spec.summary       = 'Abstracts sending physical mail from multiple APIs and services'
  spec.homepage      = 'https://github.com/eligoenergy/letter_service.git'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'lob'

  spec.add_dependency 'postalmethods'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'factory_girl'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
