require 'rails_helper'

RSpec.describe "/users", type: :request do
  describe "POST /create" do
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

  describe "POST /index" do
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

  describe "POST /sleeps/start" do
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
      expect(user.sleeps[0].clock_in).to eq(time)
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

  describe "POST /sleeps/end" do
    it "can end sleep" do
      user = User.create!(name: "Alice")

      datetime_start = "2023-06-20 20:00:00"
      datetime_end = "2023-06-20 21:00:00"

      user.clock_in(datetime_start)

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
      expect(user.sleeps[0].clock_out).to eq(datetime_end)
    end

    it "cannot clock out if less than clock in" do
      user = User.create!(name: "Alice")
      user.clock_in("2023-06-20 21:59:59")

      params = {
        datetime: "2023-06-05 21:59:59"
      }

      post "/users/#{user.id}/sleeps/end",
            params: params, as: :json

      expect(response).to have_http_status(:conflict)

      body = JSON.parse(response.body)
      expect(body["error"]).to include("Clock out cannot be less than clock in")
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

  describe "POST /follow" do
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

  describe "POST /unfollow" do
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

  describe "GET /followings/sleeps" do
    it "can get followings' sleeps" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "John")

      last_week_clock_in = Date.today.last_week.beginning_of_week + 1.hour
      last_week_clock_out = Date.today.last_week.beginning_of_week + 2.hour
      user2.sleeps.create!(
        clock_in: last_week_clock_in,
        clock_out: last_week_clock_out,
        duration_in_second: 3600
      )
      user1.follow(user2)

      get "/users/#{user1.id}/followings/sleeps", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      expect(data[0]["clock_in"]).to eq(last_week_clock_in.strftime("%F %T"))
      expect(data[0]["clock_out"]).to eq(last_week_clock_out.strftime("%F %T"))
      expect(data[0]["duration_in_second"]).to eq(last_week_clock_out - last_week_clock_in)
      expect(data[0]["user"]["name"]).to eq("John")
    end

    it "sorted by sleep duration descending" do
      user1 = User.create!(name: "Alice")
      
      user_with_shorter_duration = User.create!(name: "John")

      last_week_clock_in1 = Date.today.last_week.beginning_of_week + 30.minute
      last_week_clock_out1 = Date.today.last_week.beginning_of_week + 1.hour
      user_with_shorter_duration.sleeps.create!(
        clock_in: last_week_clock_in1,
        clock_out: last_week_clock_out1,
        duration_in_second: (last_week_clock_out1 - last_week_clock_in1)
      )

      user_with_longer_duration = User.create!(name: "Bob")

      last_week_clock_in2 = Date.today.last_week.beginning_of_week + 1.hour
      last_week_clock_out2 = Date.today.last_week.beginning_of_week + 2.hour
      user_with_longer_duration.sleeps.create!(
        clock_in: last_week_clock_in2,
        clock_out: last_week_clock_out2,
        duration_in_second: (last_week_clock_out2 - last_week_clock_in2)
      )
      
      user1.follow(user_with_shorter_duration)
      user1.follow(user_with_longer_duration)

      get "/users/#{user1.id}/followings/sleeps", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]

      expect(data.size).to eq(2)

      expect(data[0]["clock_in"]).to eq(last_week_clock_in2.strftime("%F %T"))
      expect(data[0]["clock_out"]).to eq(last_week_clock_out2.strftime("%F %T"))
      expect(data[0]["duration_in_second"]).to eq(user_with_longer_duration.sleeps[0].duration_in_second)
      expect(data[0]["user"]["name"]).to eq(user_with_longer_duration.name)
    end

    it "only get data from previous week" do
      user1 = User.create!(name: "Alice")
      
      user2 = User.create!(name: "John")
      user2.sleeps.create!(
        clock_in: 2.hour.ago,
        clock_out: 1.hour.ago,
        duration_in_second: 2.hour.ago - 1.hour.ago
      )

      last_week_clock_in = Date.today.last_week.beginning_of_week + 1.hour
      last_week_clock_out = Date.today.last_week.beginning_of_week + 2.hour
      user2.sleeps.create!(
        clock_in: last_week_clock_in,
        clock_out: last_week_clock_out,
        duration_in_second: last_week_clock_out - last_week_clock_in
      )
      
      user1.follow(user2)

      get "/users/#{user1.id}/followings/sleeps", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      
      expect(data.size).to eq(1)

      expect(data[0]["clock_in"]).to eq((last_week_clock_in).strftime("%F %T"))
      expect(data[0]["clock_out"]).to eq((last_week_clock_out).strftime("%F %T"))
      expect(data[0]["duration_in_second"]).to eq(last_week_clock_out - last_week_clock_in)
      expect(data[0]["user"]["name"]).to eq(user2.name)
    end

    it "show sleep without clockout" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "John")

      last_week_clock_in = Date.today.last_week.beginning_of_week + 1.hour
      user2.sleeps.create!(
        clock_in: last_week_clock_in
      )
      user1.follow(user2)

      get "/users/#{user1.id}/followings/sleeps", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      expect(data[0]["clock_in"]).to eq(last_week_clock_in.strftime("%F %T"))
      expect(data[0]["clock_out"]).to eq(nil)
      expect(data[0]["duration_in_second"]).to eq(nil)
      expect(data[0]["user"]["name"]).to eq("John")
    end
  end

  describe "GET /sleeps" do
    it "show list of a user's sleep" do
      user1 = User.create!(name: "Alice")
      user1.sleeps.create!(
        clock_in: "2023-05-20 21:00:00",
        clock_out: "2023-05-20 21:00:00",
        duration_in_second: 3600,
        created_at: 2.hour.ago
      )
      user1.sleeps.create!(
        clock_in: "2023-05-21 22:00:00",
        clock_out: nil,
        duration_in_second: nil,
        created_at: 1.hour.ago
      )

      get "/users/#{user1.id}/sleeps", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      expect(data[0]["clock_in"]).to eq("2023-05-21 22:00:00")
      expect(data[0]["clock_out"]).to eq(nil)
      expect(data[0]["duration_in_second"]).to eq(nil)

      expect(data[1]["clock_in"]).to eq("2023-05-20 21:00:00")
      expect(data[1]["clock_out"]).to eq("2023-05-20 21:00:00")
      expect(data[1]["duration_in_second"]).to eq(3600)
    end
  end

  describe "GET /followings" do
    it "show user's followings" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "John")

      user1.follow(user2)

      get "/users/#{user1.id}/followings", as: :json

      expect(response).to have_http_status(:ok)

      data = JSON.parse(response.body)["data"]
      expect(data[0]["name"]).to eq("John")
      expect(data[0]["created_at"]).to eq(nil)
      expect(data[0]["updated_at"]).to eq(nil)
    end
  end
end
