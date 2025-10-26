# frozen_string_literal: true

module Rails
  class ButtonTo < BaseComponent
    def initialize(url:, label: nil, **kwargs)
      @url = url
      @label = label
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      if @label
        button_to(@label, @url, **@kwargs)
      else
        button_to(@url, **@kwargs) do
          content
        end
      end
    end
  end
end
