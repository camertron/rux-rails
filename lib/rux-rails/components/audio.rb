module RuxRails
  module Components
    class Audio < ViewComponent::Base
      include ActionView::Helpers::AssetUrlHelper

      attr_reader :src, :params

      def initialize(src:, **params)
        @src = src
        @params = params
      end

      def call
        audio_tag(src, **params)
      end
    end
  end
end
