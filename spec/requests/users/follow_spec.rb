require 'rails_helper'

RSpec.describe "POST /users/follow", type: :request do
  it "can follow" do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "Bob")

    params = {
      user_id: user2.id
    }

    post "/users/#{user1.id}/follow",
          params: params, as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["message"]).to eq("Follow success")

    user1.reload
    expect(user1.followings.size).to eq(1)
    expect(user1.followings[0].id).to eq(user2.id)
  end

  it "cannot follow non existing user" do
    user1 = User.create!(name: "Alice")

    params = {
      user_id: 999999
    }

    post "/users/#{user1.id}/follow",
          params: params, as: :json

    expect(response).to have_http_status(:not_found)
  end
end
