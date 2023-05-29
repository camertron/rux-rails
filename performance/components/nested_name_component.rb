class Performance::NestedNameComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end

  def call
    Rux.tag("p") {
      Rux.create_buffer.tap { |_rux_buf_|
        _rux_buf_ << "nested hello "
        _rux_buf_ << @name
      }.to_s
    }
  end
end
