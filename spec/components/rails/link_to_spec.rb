require 'spec_helper'

describe Rails::LinkTo, type: :component do
  it 'renders with defaults' do
    render_inline(described_class.new(url: "http://example.com", label: "foo"))
    expect(rendered_content).to eq("<a href=\"http://example.com\">foo</a>")
  end

  it 'renders the content between the tags' do
    render_inline(described_class.new(url: "http://example.com")) do
      "Hello, world"
    end

    expect(rendered_content).to eq("<a href=\"http://example.com\">Hello, world</a>")
  end
end
