require 'rails_helper'

RSpec.describe "GET /users/sleeps", type: :request do
  it "show list of a user's sleep" do
    user1 = User.create!(name: "Alice")
    user1.sleeps.create!(
      start_at: "2023-05-20 21:00:00",
      end_at: "2023-05-20 21:00:00",
      duration_in_second: 3600,
      created_at: 2.hour.ago
    )
    user1.sleeps.create!(
      start_at: "2023-05-21 22:00:00",
      end_at: nil,
      duration_in_second: nil,
      created_at: 1.hour.ago
    )

    get "/users/#{user1.id}/sleeps", as: :json

    expect(response).to have_http_status(:ok)

    data = JSON.parse(response.body)["data"]
    expect(data[0]["start_at"]).to eq("2023-05-21 22:00:00")
    expect(data[0]["end_at"]).to eq(nil)
    expect(data[0]["duration_in_second"]).to eq(nil)

    expect(data[1]["start_at"]).to eq("2023-05-20 21:00:00")
    expect(data[1]["end_at"]).to eq("2023-05-20 21:00:00")
    expect(data[1]["duration_in_second"]).to eq(3600)
  end
end
