require 'spec_helper'

describe "html safety", type: :component do
  it "escapes HTML" do
    render_inline(HtmlSafetyComponent.new(value: "<p>Foo</p>"))
    expect(rendered_content).to eq(
      "<div>&lt;p&gt;Foo&lt;/p&gt;</div>"
    )
  end
end
