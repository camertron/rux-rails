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

  s.add_dependency 'rux', '~> 1.0'
  s.add_dependency 'railties', '>= 5.0'
  s.add_dependency 'view_component', '~> 2.0'

  s.require_path = 'lib'

  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'LICENSE', 'CHANGELOG.md', 'README.md', 'Rakefile', 'rux-rails.gemspec']
end
