require 'rails_helper'

RSpec.describe "POST /users/sleeps/start", type: :request do
  it "can start sleep" do
    user = User.create!(name: "Alice")

    time = "2023-06-20 21:59:59"

    params = {
      datetime: time
    }

    post "/users/#{user.id}/sleeps/start",
          params: params, as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["message"]).to eq("Start sleep success")

    data = body["data"]
    expect(data["id"]).not_to eq(nil)
    expect(data["start_at"]).to eq(time)
    expect(data["end_at"]).to eq(nil)
    expect(data["duration_in_second"]).to eq(nil)

    user.reload
    expect(user.sleeps[0].start_at).to eq(time)
  end

  it "return 404 if user not found" do
    time = "2023-06-20 21:59:59"

    params = {
      datetime: time
    }

    post "/users/999999/sleeps/start",
          params: params, as: :json

    expect(response).to have_http_status(:not_found)
  end

  it "datetime empty" do
    user = User.create!(name: "Alice")

    time = "2023-06-20 21:59:59"

    params = {
      datetime: ""
    }

    post "/users/#{user.id}/sleeps/start",
          params: params, as: :json

    expect(response).to have_http_status(:bad_request)

    body = JSON.parse(response.body)
    expect(body["error"]).to eq("param is missing or the value is empty: datetime")
  end
end
