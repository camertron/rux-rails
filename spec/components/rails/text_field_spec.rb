require 'spec_helper'

describe Rails::TextField, type: :component do
  it 'renders with defaults' do
    render_inline(Rails::FormWith.new(url: "/foo")) do
      described_class.new(name: "bar").render_in(view_context)
    end

    expect(rendered_content).to include("<input type=\"text\" name=\"bar\" id=\"bar\" />")
  end
end
