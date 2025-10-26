require 'spec_helper'

describe Rails::Button, type: :component do
  it 'renders with defaults' do
    render_inline(described_class.new)
    expect(rendered_content).to eq("<button name=\"button\" type=\"submit\">Button</button>")
  end

  it 'renders with the given label' do
    render_inline(described_class.new(label: "Click me"))
    expect(rendered_content).to eq("<button name=\"button\" type=\"submit\">Click me</button>")
  end

  it 'renders with the given attributes' do
    render_inline(described_class.new(disabled: true))
    expect(rendered_content).to eq("<button name=\"button\" type=\"submit\" disabled=\"disabled\">Button</button>")
  end
end
