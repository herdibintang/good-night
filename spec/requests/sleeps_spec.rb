require 'rails_helper'

RSpec.describe "/sleeps", type: :request do
  describe "GET /index" do
    it "can show all sleeps data" do
      user1 = User.create!(name: "Alice")
      user1.sleeps.create!(
        clock_in: "2023-05-20 20:00:00",
        clock_out: "2023-05-20 21:00:00",
        duration_in_second: 3600,
        created_at: 2.hour.ago
      )

      user2 = User.create!(name: "Bob")
      user2.sleeps.create!(
        clock_in: "2023-05-21 23:00:00",
        clock_out: nil,
        duration_in_second: nil,
        created_at: 1.hour.ago
      )

      get "/sleeps", as: :json

      expect(response).to have_http_status(:ok)
      
      data = JSON.parse(response.body)["data"]
      
      expect(data[0]["clock_in"]).to eq("2023-05-21 23:00:00")
      expect(data[0]["clock_out"]).to eq(nil)
      expect(data[0]["duration_in_second"]).to eq(nil)

      expect(data[1]["clock_in"]).to eq("2023-05-20 20:00:00")
      expect(data[1]["clock_out"]).to eq("2023-05-20 21:00:00")
      expect(data[1]["duration_in_second"]).to eq(3600)
    end
  end
end
