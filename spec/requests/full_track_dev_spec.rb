require 'rails_helper'

RSpec.describe "FullTrackDevs", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/full_track_dev/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get "/full_track_dev/contact"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /wip" do
    it "returns http success" do
      get "/full_track_dev/wip"
      expect(response).to have_http_status(:success)
    end
  end

end
