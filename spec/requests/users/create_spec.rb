require 'rails_helper'

RSpec.describe "POST /users/create", type: :request do
  it "can create user" do
    params = {
      name: "Alice"
    }

    post "/users", params: params, as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["message"]).to eq("Create user success")
    expect(body["data"]["id"]).not_to eq(nil)
    expect(body["data"]["name"]).to eq("Alice")

    expect(User.last.name).to eq("Alice")
  end

  it "return 400 when name is empty" do
    params = {
      name: ""
    }

    post "/users", params: params, as: :json

    expect(response).to have_http_status(:bad_request)

    body = JSON.parse(response.body)
    expect(body["error"]).to eq("param is missing or the value is empty: name")
  end
end
