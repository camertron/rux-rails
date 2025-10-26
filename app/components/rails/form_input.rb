# frozen_string_literal: true

require "use_context"

module Rails
  class BuilderNotFoundError < StandardError; end

  class FormInput < BaseComponent
    include UseContext::ContextMethods

    def builder
      use_context(:rux, :form_builder).tap do |builder|
        unless builder
          raise BuilderNotFoundError, "expected #{self.class.name} to be used inside a Rails form_with or form_for block"
        end
      end
    end
  end
end
