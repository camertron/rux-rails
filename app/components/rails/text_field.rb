# frozen_string_literal: true

module Rails
  class TextField < FormInput
    def initialize(name:, **kwargs)
      @name = name
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      builder.text_field(@name, **@kwargs)
    end
  end
end
