module RuxRails
  autoload :Components,      'rux-rails/components'
  autoload :OutputBuffer,    'rux-rails/output_buffer'
  autoload :RuxLoader,       'rux-rails/rux_loader'
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
  end

  self.transpile_on_load = true
end


require 'rux'

if defined?(Rails)
  require 'rux-rails/engine'
end

Rux.tag_builder = RuxRails.tag_builder
Rux.buffer = RuxRails::OutputBuffer
