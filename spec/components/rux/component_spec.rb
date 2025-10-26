require 'spec_helper'

describe Rux::Component, type: :component do
  it 'renders the given instance' do
    render_inline(Rux::Component.new(instance: Image.new(src: "foo.png")))

    expect(rendered_content).to include("<img src=\"/images/foo.png\" />")
  end
end
