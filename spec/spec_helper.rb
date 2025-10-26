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
    include Capybara::RSpecMatchers

    let(:app) { Rails.application }

    before(:each) do
      Dir.glob("spec/dummy/app/components/*.rb").each do |f|
        File.unlink(f)
      end
    end

    def view_context
      respond_to?(:vc_test_view_context) ? vc_test_view_context : vc_test_controller.view_context
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
  config.include ViewComponent::TestHelpers, type: :component
end
