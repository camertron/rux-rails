# frozen_string_literal: true

module Rails
  class HiddenField < FormInput
    def initialize(name:, **kwargs)
      @name = name
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      builder.hidden_field(@name, **@kwargs)
    end
  end
end
