module RuxRails
  module Components
    class Image < ViewComponent::Base
      include ActionView::Helpers::AssetUrlHelper

      attr_reader :src, :params

      def initialize(src:, **params)
        @src = src
        @params = params
      end

      def call
        image_tag(src, **params)
      end
    end
  end
end
