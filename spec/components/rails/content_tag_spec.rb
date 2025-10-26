require 'spec_helper'

describe Rails::ContentTag, type: :component do
  it 'renders an empty tag by default' do
    render_inline(described_class.new(tag: :div))
    expect(rendered_content).to eq("<div></div>")
  end

  it 'renders content within the tags' do
    render_inline(described_class.new(tag: :div)) { 'Hello, world' }
    expect(rendered_content).to eq("<div>Hello, world</div>")
  end
end
