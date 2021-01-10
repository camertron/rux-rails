module RuxRails
  autoload :Components,      'rux-rails/components'
  autoload :TagBuilder,      'rux-rails/tag_builder'
  autoload :TemplateHandler, 'rux-rails/template_handler'
  autoload :Visitor,         'rux-rails/visitor'

  class << self
    attr_accessor :zeitwerk_mode
    alias_method :zeitwerk_mode?, :zeitwerk_mode

    def visitor
      @visitor ||= Visitor.new
    end

    def tag_builder
      @tag_builder ||= TagBuilder.new
    end
  end
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

require 'rux'
require 'rux-rails/railtie'
require 'view_component/engine'

ViewComponent::Base.send(:include, RuxRails::Components)
Rux.tag_builder = RuxRails.tag_builder
