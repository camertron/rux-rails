# frozen_string_literal: true

module Rails
  class Label < FormInput
    def initialize(name:, **kwargs)
      @name = name
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      builder.label(@name, content, **@kwargs)
    end
  end
end
