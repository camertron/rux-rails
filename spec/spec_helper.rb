require 'pry-byebug'

ENV['RAILS_ENV'] ||= 'test'

require 'rails'
require 'rux-rails'

require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Dir.chdir(File.join(*%w(spec dummy))) do
  require File.expand_path(File.join(*%w(dummy config application)), __dir__)
  RuxRails::DummyApplication.initialize!
end

require 'rspec/rails'

module SpecHelpers
  extend RSpec::SharedContext

  let(:app) { Rails.application }
end

RSpec.configure do |config|
  config.include(SpecHelpers)
end
