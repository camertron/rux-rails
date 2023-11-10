require 'active_support'

module RuxRails
  class OutputBuffer < ActionView::OutputBuffer
    alias :safe_append :safe_append=
    alias :append :append=
  end
end
