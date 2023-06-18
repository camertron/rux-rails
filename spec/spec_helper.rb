require 'pry-byebug'

ENV['RAILS_ENV'] ||= 'test'

require 'rails'
require 'action_controller/railtie'
require 'rux-rails'

Dir.chdir(File.join(*%w(spec dummy))) do
  require File.expand_path(File.join(*%w(dummy config application)), __dir__)
  RuxRails::DummyApplication.initialize!
end

require 'rspec/rails'

module SpecHelpers
  extend RSpec::SharedContext

  let(:app) { Rails.application }

  before(:each) do
    Dir.glob("spec/dummy/app/components/*.rb").each do |f|
      File.unlink(f)
    end
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)
  config.include(Capybara::RSpecMatchers, type: :request)
end
