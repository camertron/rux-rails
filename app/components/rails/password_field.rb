# frozen_string_literal: true

module Rails
  class PasswordField < FormInput
    def initialize(name:, **kwargs)
      @name = name
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      builder.password_field(@name, **@kwargs)
    end
  end
end
