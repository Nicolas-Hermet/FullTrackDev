require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /landing" do
    it "returns http success" do
      get "/static_pages/landing"
      expect(response).to have_http_status(:success)
    end
  end

end
