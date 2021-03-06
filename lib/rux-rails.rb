module RuxRails
  autoload :Components,      'rux-rails/components'
  autoload :TagBuilder,      'rux-rails/tag_builder'
  autoload :TemplateHandler, 'rux-rails/template_handler'
  autoload :Visitor,         'rux-rails/visitor'

  class << self
    attr_accessor :zeitwerk_mode, :transpile_on_load
    alias_method :zeitwerk_mode?, :zeitwerk_mode

    def visitor
      @visitor ||= Visitor.new
    end

    def tag_builder
      @tag_builder ||= TagBuilder.new
    end

    def transpile_on_load?
      transpile_on_load.call
    end
  end

  self.transpile_on_load = -> () { true }
end

begin
  require 'zeitwerk'
rescue LoadError
  require 'rux-rails/core_ext/kernel'
  require 'rux-rails/ext/activesupport/dependencies'

  RuxRails.zeitwerk_mode = false
else
  require 'rux-rails/core_ext/kernel_zeitwerk'
  require 'rux-rails/ext/zeitwerk/loader'

  RuxRails.zeitwerk_mode = true
end

begin
  require 'bootsnap'
rescue LoadError
else
  require 'rux-rails/ext/bootsnap/autoload'
end

require 'rux'
require 'rux-rails/railtie'
require 'view_component/engine'
require 'active_support'

ViewComponent::Base.send(:include, RuxRails::Components)
Rux.tag_builder = RuxRails.tag_builder
Rux.buffer = ActiveSupport::SafeBuffer
