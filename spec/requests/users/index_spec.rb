require 'rails_helper'

RSpec.describe "GET /users", type: :request do
  it "show user list" do
    User.create!(name: "Alice")

    get "/users", as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    
    expect(body["data"][0]["id"]).not_to eq(nil)
    expect(body["data"][0]["name"]).to eq("Alice")
    expect(body["data"][0]["created_at"]).to eq(nil)
    expect(body["data"][0]["updated_at"]).to eq(nil)
  end
end
