require 'active_support'

module RuxRails
  class SafeBuffer < ActiveSupport::SafeBuffer
    def <<(value)
      if value.is_a?(Array)
        super(value.map { |v| html_escape_interpolated_argument(v) }.join.html_safe)
      else
        super
      end
    end
  end
end
