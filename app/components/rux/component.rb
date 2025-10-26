# frozen_string_literal: true

module Rux
  # For rendering a component that you already have an instance of, perhaps
  # created in another component's constructor
  class Component < ViewComponent::Base
    def initialize(instance:)
      @instance = instance
    end

    def call
      render(@instance)
    end
  end
end
