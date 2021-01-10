module RuxRails
  module TemplateHandler
    def self.call(template, source = nil)
      # rails 5 passes 1 argument (template), rails 6 passes two arguments
      # (template, source)
      source ||= template.source
      ::Rux.to_ruby(source, RuxRails.visitor)
    end
  end
end
