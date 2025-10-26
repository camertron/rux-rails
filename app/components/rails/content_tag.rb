# frozen_string_literal: true

module Rails
  class ContentTag < BaseComponent
    def initialize(tag:, **kwargs)
      @tag = tag
      @kwargs = kwargs
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      content_tag(@tag, content, **@kwargs)
    end
  end
end
