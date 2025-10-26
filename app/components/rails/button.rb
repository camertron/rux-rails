# frozen_string_literal: true

module Rails
  class Button < BaseComponent
    def initialize(label: "Button", **kwargs)
      @label = label
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      button_tag(@label, **@kwargs)
    end
  end
end
