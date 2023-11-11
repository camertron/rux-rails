require 'spec_helper'

describe HomeController, type: :request do
  describe '#index' do
    before(:each) do
      # Force a recompile to avoid test pollution
      HomeComponent.compile
    end

    it 'transpiles the file' do
      get '/'

      expect(response).to have_http_status(:ok)
      expect(response.body).to(
        have_selector("div.container img[src='/images/cat.png'] + button", text: "Click Me!")
      )
    end

    it "allows hot reloading" do
      get "/"

      expect(response).to have_http_status(:ok)
      expect(response.body).to(
        have_selector(".container", text: "Click Me!")
      )

      new_contents = <<~RUX
        class HomeComponent < ViewComponent::Base
          def call
            <div class="container">
              <Image src="cat.png" size="40" />
              <Button outline={true} disabled size={:large}>
                Click if you dare
              </Button>
            </div>
          end
        end
      RUX

      with_file_contents(Rails.root.join(*%w[app components home_component.rux]), new_contents) do
        get "/"

        expect(response).to have_http_status(:ok)
        expect(response.body).to(
          have_selector(".container", text: "Click if you dare")
        )
      end
    end
  end
end
