# frozen_string_literal: true

module Rails
  class BaseComponent < ViewComponent::Base
    private

    def normalize_kwargs(kwargs)
      klass = kwargs.delete(:class)
      klasses = kwargs.delete(:classes)
      return kwargs unless klass || klasses

      kwargs[:class] = class_names(klass, klasses)
      kwargs
    end
  end
end
