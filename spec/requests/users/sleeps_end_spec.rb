require 'rails_helper'

RSpec.describe "POST /users/sleeps/end", type: :request do
  it "can end sleep" do
    user = User.create!(name: "Alice")

    datetime_start = "2023-06-20 20:00:00"
    datetime_end = "2023-06-20 21:00:00"

    user.start_sleep(datetime_start)

    params = {
      datetime: datetime_end
    }

    post "/users/#{user.id}/sleeps/end",
          params: params, as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["message"]).to eq("End sleep success")

    data = body["data"]
    expect(data["id"]).not_to eq(nil)
    expect(data["start_at"]).to eq(datetime_start)
    expect(data["end_at"]).to eq(datetime_end)
    expect(data["duration_in_second"]).to eq(3600)

    user.reload
    expect(user.sleeps[0].end_at).to eq(datetime_end)
  end

  it "cannot end sleep if less than start sleep" do
    user = User.create!(name: "Alice")
    user.start_sleep("2023-06-20 21:59:59")

    params = {
      datetime: "2023-06-05 21:59:59"
    }

    post "/users/#{user.id}/sleeps/end",
          params: params, as: :json

    expect(response).to have_http_status(:unprocessable_entity)

    body = JSON.parse(response.body)
    expect(body["error"]).to include("Sleeps invalid")
  end

  it "datetime empty" do
    user = User.create!(name: "Alice")

    time = "2023-06-20 21:59:59"

    params = {
      datetime: ""
    }

    post "/users/#{user.id}/sleeps/end",
          params: params, as: :json

    expect(response).to have_http_status(:bad_request)

    body = JSON.parse(response.body)
    expect(body["error"]).to eq("param is missing or the value is empty: datetime")
  end
end
