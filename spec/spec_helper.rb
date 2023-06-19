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

module RuxRails
  module SpecHelpers
    extend RSpec::SharedContext

    let(:app) { Rails.application }

    before(:each) do
      Dir.glob("spec/dummy/app/components/*.rb").each do |f|
        File.unlink(f)
      end
    end

    def with_file_contents(path, contents)
      old_contents = ::File.read(path)
      ::File.write(path, contents)
      yield
    ensure
      ::File.write(path, old_contents)
    end
  end
end

RSpec.configure do |config|
  config.include(RuxRails::SpecHelpers)
  config.include(Capybara::RSpecMatchers, type: :request)
end
