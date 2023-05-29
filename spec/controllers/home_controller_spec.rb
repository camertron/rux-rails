require 'spec_helper'

describe HomeController, type: :request do
  describe '#index' do
    it 'works' do
      get '/'

      expect(response).to have_http_status(:ok)
      expect(response.body).to(
        have_selector("div.container img[src='/images/cat.png'] + button", text: "Click Me!")
      )
    end
  end
end
