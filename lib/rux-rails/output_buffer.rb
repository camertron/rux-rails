require 'action_view'

module RuxRails
  class OutputBuffer < ActionView::OutputBuffer
    def safe_append(obj)
      Array(obj).each { |o| self.safe_append=(o) }
    end

    def append(obj)
      Array(obj).each { |o| self.append=(o) }
    end
  end
end
