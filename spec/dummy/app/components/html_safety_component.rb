class HtmlSafetyComponent < ViewComponent::Base
  def initialize(value:)
    @value = value
  end

  def call
    Rux.tag("div") {
      Rux.create_buffer.tap { |_rux_buf_|
        _rux_buf_.append(@value)
      }.to_s
    }
  end
end
