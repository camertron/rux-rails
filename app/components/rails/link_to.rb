# frozen_string_literal: true

module Rails
  class LinkTo < BaseComponent
    def initialize(url:, label: nil, **kwargs)
      @url = url
      @label = label
      @kwargs = normalize_kwargs(kwargs)
    end

    def call
      if @label
        link_to(@label, @url, **@kwargs)
      else
        link_to(@url, **@kwargs) do
          content
        end
      end
    end
  end
end
