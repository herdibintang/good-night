require 'rails_helper'

RSpec.describe "POST /users/unfollow", type: :request do
  it "can unfollow" do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "Bob")
    user1.follow(user2)

    params = {
      user_id: user2.id
    }

    post "/users/#{user1.id}/unfollow",
          params: params, as: :json

    expect(response).to have_http_status(:ok)

    body = JSON.parse(response.body)
    expect(body["message"]).to eq("Unfollow success")

    user1.reload
    expect(user1.followings.size).to eq(0)
  end

  it "return 409 if unfollow not existing relation" do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "Bob")

    params = {
      user_id: user2.id
    }

    post "/users/#{user1.id}/unfollow",
          params: params, as: :json

    expect(response).to have_http_status(:conflict)

    body = JSON.parse(response.body)
    expect(body["error"]).to eq("Not following this user")
  end
end
