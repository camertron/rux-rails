module RuxRails
  module Components
    class Video < ViewComponent::Base
      include ActionView::Helpers::AssetUrlHelper

      attr_reader :src, :params

      def initialize(src:, **params)
        @src = src
        @params = params
      end

      def call
        video_tag(src, **params)
      end
    end
  end
end
