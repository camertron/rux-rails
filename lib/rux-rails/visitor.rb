require 'rux'

module RuxRails
  class Visitor < ::Rux::DefaultVisitor
    def visit_text(*args)
      "#{super}.html_safe"
    end
  end
end
