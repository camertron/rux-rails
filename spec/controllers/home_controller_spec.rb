require 'spec_helper'

describe HomeController, type: :request do
  describe '#index' do
    it 'works' do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
