require 'rails_helper'

RSpec.describe "/users", type: :request do
  describe "POST /clock-in" do
    it "can clock in" do
      user = User.create!

      time = "2023-06-20 21:59:59"

      params = {
        datetime: time
      }

      post "/users/#{user.id}/clock-in",
            params: params, as: :json

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["message"]).to eq("Clock in success")

      user.reload
      expect(user.sleeps[0].clock_in).to eq(time)
    end

    it "datetime empty" do
      user = User.create!

      time = "2023-06-20 21:59:59"

      params = {
        datetime: ""
      }

      post "/users/#{user.id}/clock-in",
            params: params, as: :json

      expect(response).to have_http_status(:bad_request)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("param is missing or the value is empty: datetime")
    end
  end

  describe "POST /clock-out" do
    it "can clock out" do
      user = User.create!

      time = "2023-06-20 21:59:59"

      user.clock_in(time)

      params = {
        datetime: time
      }

      post "/users/#{user.id}/clock-out",
            params: params, as: :json

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["message"]).to eq("Clock out success")

      user.reload
      expect(user.sleeps[0].clock_out).to eq(time)
    end

    it "datetime empty" do
      user = User.create!

      time = "2023-06-20 21:59:59"

      params = {
        datetime: ""
      }

      post "/users/#{user.id}/clock-out",
            params: params, as: :json

      expect(response).to have_http_status(:bad_request)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("param is missing or the value is empty: datetime")
    end
  end

  describe "POST /follow" do
    it "can follow" do
      user1 = User.create!
      user2 = User.create!

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
  end

  describe "POST /unfollow" do
    it "can unfollow" do
      user1 = User.create!
      user2 = User.create!
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
  end
end
