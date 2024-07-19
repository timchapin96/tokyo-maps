require 'rails_helper'

RSpec.describe Api::V1::MapsController, type: :controller do

  describe "GET #api_key" do
    it "returns http success" do
      get :api_key
      expect(response).to have_http_status(:success)
    end
  end

end
