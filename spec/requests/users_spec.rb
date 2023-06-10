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
end
