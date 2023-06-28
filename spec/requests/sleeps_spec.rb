require 'rails_helper'

RSpec.describe "/sleeps", type: :request do
  describe "GET /index" do
    it "can show all sleeps data" do
      dbl = double
      sleep1 = double(
        id: 1,
        start_at: "2023-05-21 23:00:00".to_datetime,
        end_at: nil,
        duration_in_second: nil,
        user: double(
          name: "Bob"
        )
      )
      sleep2 = double(
        id: 2,
        start_at: "2023-05-20 20:00:00".to_datetime,
        end_at: "2023-05-20 21:00:00".to_datetime,
        duration_in_second: 3600,
        user: double(
          name: "Alice"
        )
      )

      allow(dbl).to receive(:sleeps).and_return([
        sleep1,
        sleep2
      ])
      allow(ViewSleepsUseCase).to receive(:call).and_return(dbl)

      user1 = User.create!(name: "Alice")
      user1.sleeps.create!(
        start_at: "2023-05-20 20:00:00",
        end_at: "2023-05-20 21:00:00",
        duration_in_second: 3600,
        created_at: 2.hour.ago
      )

      user2 = User.create!(name: "Bob")
      user2.sleeps.create!(
        start_at: "2023-05-21 23:00:00",
        end_at: nil,
        duration_in_second: nil,
        created_at: 1.hour.ago
      )

      get "/sleeps", as: :json

      expect(response).to have_http_status(:ok)
      
      data = JSON.parse(response.body)["data"]
      
      expect(data[0]["id"]).not_to eq(nil)
      expect(data[0]["start_at"]).to eq("2023-05-21 23:00:00")
      expect(data[0]["end_at"]).to eq(nil)
      expect(data[0]["duration_in_second"]).to eq(nil)
      expect(data[0]["user"]["name"]).to eq("Bob")

      expect(data[1]["id"]).not_to eq(nil)
      expect(data[1]["start_at"]).to eq("2023-05-20 20:00:00")
      expect(data[1]["end_at"]).to eq("2023-05-20 21:00:00")
      expect(data[1]["duration_in_second"]).to eq(3600)
      expect(data[1]["user"]["name"]).to eq("Alice")
    end
  end
end
