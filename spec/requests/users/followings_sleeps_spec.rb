require 'rails_helper'

RSpec.describe "GET /users/followings/sleeps", type: :request do
  it "can get followings' sleeps" do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "John")

    last_week_start_at = Date.today.last_week.beginning_of_week + 1.hour
    last_week_end_at = Date.today.last_week.beginning_of_week + 2.hour
    user2.sleeps.create!(
      start_at: last_week_start_at,
      end_at: last_week_end_at,
      duration_in_second: 3600
    )
    user1.follow(user2)

    get "/users/#{user1.id}/followings/sleeps", as: :json

    expect(response).to have_http_status(:ok)

    data = JSON.parse(response.body)["data"]
    expect(data[0]["id"]).not_to eq(nil)
    expect(data[0]["start_at"]).to eq(last_week_start_at.strftime("%F %T"))
    expect(data[0]["end_at"]).to eq(last_week_end_at.strftime("%F %T"))
    expect(data[0]["duration_in_second"]).to eq(last_week_end_at - last_week_start_at)
    expect(data[0]["user"]["id"]).not_to eq(nil)
    expect(data[0]["user"]["name"]).to eq("John")
  end

  it "sorted by sleep duration descending" do
    user1 = User.create!(name: "Alice")
    
    user_with_shorter_duration = User.create!(name: "John")

    last_week_start_at1 = Date.today.last_week.beginning_of_week + 30.minute
    last_week_end_at1 = Date.today.last_week.beginning_of_week + 1.hour
    user_with_shorter_duration.sleeps.create!(
      start_at: last_week_start_at1,
      end_at: last_week_end_at1,
      duration_in_second: (last_week_end_at1 - last_week_start_at1)
    )

    user_with_longer_duration = User.create!(name: "Bob")

    last_week_start_at2 = Date.today.last_week.beginning_of_week + 1.hour
    last_week_end_at2 = Date.today.last_week.beginning_of_week + 2.hour
    user_with_longer_duration.sleeps.create!(
      start_at: last_week_start_at2,
      end_at: last_week_end_at2,
      duration_in_second: (last_week_end_at2 - last_week_start_at2)
    )
    
    user1.follow(user_with_shorter_duration)
    user1.follow(user_with_longer_duration)

    get "/users/#{user1.id}/followings/sleeps", as: :json

    expect(response).to have_http_status(:ok)

    data = JSON.parse(response.body)["data"]

    expect(data.size).to eq(2)

    expect(data[0]["start_at"]).to eq(last_week_start_at2.strftime("%F %T"))
    expect(data[0]["end_at"]).to eq(last_week_end_at2.strftime("%F %T"))
    expect(data[0]["duration_in_second"]).to eq(user_with_longer_duration.sleeps[0].duration_in_second)
    expect(data[0]["user"]["name"]).to eq(user_with_longer_duration.name)
  end

  it "only get data from previous week" do
    user1 = User.create!(name: "Alice")
    
    user2 = User.create!(name: "John")
    user2.sleeps.create!(
      start_at: 2.hour.ago,
      end_at: 1.hour.ago,
      duration_in_second: 2.hour.ago - 1.hour.ago
    )

    last_week_start_at = Date.today.last_week.beginning_of_week + 1.hour
    last_week_end_at = Date.today.last_week.beginning_of_week + 2.hour
    user2.sleeps.create!(
      start_at: last_week_start_at,
      end_at: last_week_end_at,
      duration_in_second: last_week_end_at - last_week_start_at
    )
    
    user1.follow(user2)

    get "/users/#{user1.id}/followings/sleeps", as: :json

    expect(response).to have_http_status(:ok)

    data = JSON.parse(response.body)["data"]
    
    expect(data.size).to eq(1)

    expect(data[0]["start_at"]).to eq((last_week_start_at).strftime("%F %T"))
    expect(data[0]["end_at"]).to eq((last_week_end_at).strftime("%F %T"))
    expect(data[0]["duration_in_second"]).to eq(last_week_end_at - last_week_start_at)
    expect(data[0]["user"]["name"]).to eq(user2.name)
  end

  it "show sleep without end sleep" do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "John")

    last_week_start_at = Date.today.last_week.beginning_of_week + 1.hour
    user2.sleeps.create!(
      start_at: last_week_start_at
    )
    user1.follow(user2)

    get "/users/#{user1.id}/followings/sleeps", as: :json

    expect(response).to have_http_status(:ok)

    data = JSON.parse(response.body)["data"]
    expect(data[0]["start_at"]).to eq(last_week_start_at.strftime("%F %T"))
    expect(data[0]["end_at"]).to eq(nil)
    expect(data[0]["duration_in_second"]).to eq(nil)
    expect(data[0]["user"]["name"]).to eq("John")
  end
end
