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

    def with_file_contents(path, contents)
      old_contents = ::File.read(path)
      ::File.write(path, contents)
      yield
    ensure
      ::File.write(path, old_contents)
    end

    attr_reader :rendered_content

    def page
      @page ||= Capybara::Node::Simple.new(rendered_content)
    end

    def render_inline(component, **args, &block)
      @page = nil
      @rendered_content =
        if Rails.version.to_f >= 6.1
          vc_test_controller.view_context.render(component, args, &block)
        else
          vc_test_controller.view_context.render_component(component, &block)
        end

      Nokogiri::HTML.fragment(@rendered_content)
    end

    def vc_test_controller
      @vc_test_controller ||= __vc_test_helpers_build_controller(ViewComponent::Base.test_controller.constantize)
    end

    def __vc_test_helpers_build_controller(klass)
      klass.new.tap { |c| c.request = vc_test_request }.extend(Rails.application.routes.url_helpers)
    end

    def vc_test_request
      @vc_test_request ||=
        begin
          out = ActionDispatch::TestRequest.create
          out.session = ActionController::TestSession.new
          out
        end
    end
  end
end

RSpec.configure do |config|
  config.include(RuxRails::SpecHelpers)
  config.include(Capybara::RSpecMatchers, type: :request)
end
