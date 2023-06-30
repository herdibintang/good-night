require 'rails_helper'

RSpec.describe "/users", type: :request do
  describe "GET /followings" do
    it "show user's followings" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "John")

      user1.follow(user2)

      get "/users/#{user1.id}/followings", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      expect(data[0]["name"]).to eq("John")
      expect(data[0]["created_at"]).to eq(nil)
      expect(data[0]["updated_at"]).to eq(nil)
    end
  end
end
