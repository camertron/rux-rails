require 'spec_helper'

describe Rails::FormWith, type: :component do
  it 'renders with defaults' do
    render_inline(described_class.new(url: "/foo"))
    expect(rendered_content).to include("<form action=\"/foo\" accept-charset=\"UTF-8\" method=\"post\"><input type=\"hidden\" name=\"authenticity_token\"")
  end

  it 'adds the builder to the rux context' do
    builder = nil

    render_inline(described_class.new(url: "/foo")) do
      UseContext.use_context(:rux, :form_builder) do |f|
        builder = f
      end
    end

    expect(builder).to be_a(ActionView::Helpers::FormBuilder)
  end
end
