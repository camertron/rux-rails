require 'spec_helper'

describe Rails::HiddenField, type: :component do
  it 'renders with defaults' do
    render_inline(Rails::FormWith.new(url: "/foo")) do
      described_class.new(name: "bar").render_in(view_context)
    end

    expect(rendered_content).to include("<input autocomplete=\"off\" type=\"hidden\" name=\"bar\" id=\"bar\" />")
  end
end
