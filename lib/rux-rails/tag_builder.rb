require 'rux'

module RuxRails
  class TagBuilder < ::Rux::DefaultTagBuilder
    def call(*args)
      super.html_safe
    end
  end
end
