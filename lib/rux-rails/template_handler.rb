module RuxRails
  module TemplateHandler
    def self.call(template, source)
      ::Rux.to_ruby(source, RuxRails.visitor)
    end
  end
end
