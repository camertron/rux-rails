# frozen_string_literal: true

require "use_context"

module Rails
  class FormWith < BaseComponent
    include UseContext::ContextMethods

    def initialize(*args, **kwargs)
      @args = args
      @kwargs = normalize_kwargs(kwargs)
    end
  end
end
