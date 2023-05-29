class Performance::NameComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end

  def call
    Rux.tag("div") {
      Rux.create_buffer.tap { |_rux_buf_|
        _rux_buf_ << Rux.tag("h1") {
          Rux.create_buffer.tap { |_rux_buf_|
            _rux_buf_ << "hello "
            _rux_buf_ << @name
          }.to_s
        }
        _rux_buf_ << 50.times.map {
          render(Performance::NestedNameComponent.new(name: @name))
        }
      }.to_s
    }
  end
end
