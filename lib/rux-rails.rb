module RuxRails
  autoload :Components,      'rux-rails/components'
  autoload :SafeBuffer,      'rux-rails/safe_buffer'
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


require 'rux'
require 'rux-rails/railtie'

# require both of these to support multiple versions of view_component
require 'view_component'
require 'view_component/engine'

ViewComponent::Base.send(:include, RuxRails::Components)
Rux.tag_builder = RuxRails.tag_builder
Rux.buffer = RuxRails::SafeBuffer
