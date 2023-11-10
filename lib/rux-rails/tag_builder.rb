require 'rux'

module RuxRails
  class TagBuilder < ::Rux::DefaultTagBuilder
    def call(*args, &block)
      build(*args, &block).html_safe
    end
  end
end
