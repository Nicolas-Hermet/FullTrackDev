require 'rails_helper'

RSpec.describe "FullTrackDevs", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/contact"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /wip" do
    it "returns http success" do
      get "/wip"
      expect(response).to have_http_status(:success)
    end
  end
end
