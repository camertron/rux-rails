require 'spec_helper'

describe Rails::ButtonTo, type: :component do
  it 'renders with defaults' do
    render_inline(described_class.new(url: "http://example.com"))
    expect(rendered_content).to include(
      /<form .* action=\"http:\/\/example.com".*<button type=\"submit\"><\/button>/
    )
  end

  it 'renders with a label' do
    render_inline(described_class.new(label: "Click me", url: "http://example.com"))
    expect(rendered_content).to include(
      /<form .* action=\"http:\/\/example.com".*<button type=\"submit\">Click me<\/button>/
    )
  end

  it 'renders with the content as the label' do
    render_inline(described_class.new(url: "http://example.com")) { "Click me" }
    expect(rendered_content).to include(
      /<form .* action=\"http:\/\/example.com".*<button type=\"submit\">Click me<\/button>/
    )
  end
end
