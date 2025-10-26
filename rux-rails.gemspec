$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rux-rails/version'

Gem::Specification.new do |s|
  s.name     = 'rux-rails'
  s.version  = ::RuxRails::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/rux-rails'
  s.description = s.summary = 'Rux view components on Rails.'
  s.platform = Gem::Platform::RUBY

  s.add_dependency 'rux', '~> 1.3'
  s.add_dependency 'railties', '>= 5.0'
  s.add_dependency 'view_component', '>= 2', '< 5'
  s.add_dependency 'onload', '~> 1.1'
  s.add_dependency 'use_context', '~> 1.2'

  s.require_path = 'lib'

  s.files = Dir['{app,lib,spec}/**/*', 'Gemfile', 'LICENSE', 'CHANGELOG.md', 'README.md', 'Rakefile', 'rux-rails.gemspec']
end
