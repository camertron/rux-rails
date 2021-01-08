module RuxRails
  module TemplateHandler
    def self.call(template, source)
      ::Rux::Parser.parse(source).to_ruby
    end
  end
end
