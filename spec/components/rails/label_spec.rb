require 'spec_helper'

describe Rails::Label, type: :component do
  it 'renders with defaults' do
    render_inline(Rails::FormWith.new(url: "/foo")) do
      described_class.new(name: "bar").render_in(view_context)
    end

    expect(rendered_content).to include("<label for=\"bar\">Bar</label>")
  end

  it 'renders content within the tags' do
    render_inline(Rails::FormWith.new(url: "/foo")) do
      described_class.new(name: "bar").render_in(view_context) do
        "Hello, world"
      end
    end

    expect(rendered_content).to include("<label for=\"bar\">Hello, world</label>")
  end
end
