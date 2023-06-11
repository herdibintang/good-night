require 'rails_helper'

RSpec.describe User, type: :model do
  it "must have a name" do
    user = User.new

    expect(user).not_to be_valid
  end

  context "clock in" do
    it "can do clock in" do
      user = User.create!(name: "Alice")

      time = "2023-06-20 21:59:59"

      user.clock_in(time)

      expect(user.sleeps[0].clock_in.strftime("%F %T")).to eq(time)
    end

    it "cannot do clock in if there is a clock in without clock out" do
      user = User.create!(name: "Alice")
      time = "2023-06-20 21:59:59"
      user.sleeps.create!(clock_in: time)
  
      user.clock_in(time)
  
      expect(user.errors.size).not_to eq(0)
      expect(user.sleeps.size).to eq(1)
      expect(user.errors.full_messages).to include("Cannot clock in if there is a clock in without clock out")
    end
  end

  context "clock out" do
    it "can do clock out" do
      user = User.create!(name: "Alice")
      user.clock_in("2023-06-20 20:59:59")

      time = "2023-06-20 21:59:59"

      user.clock_out(time)

      expect(user.sleeps[0].clock_out.strftime("%F %T")).to eq(time)
      expect(user.sleeps[0].duration_in_second).to eq(3600)
    end

    it "cannot do clock out if there is no previous check in" do
      user = User.create!(name: "Alice")

      time = "2023-06-20 21:59:59"

      user.clock_out(time)

      expect(user.errors.size).not_to eq(0)
      expect(user.sleeps.last).to eq(nil)
      expect(user.errors.full_messages).to include("Cannot clock out without previous clock in")
    end
  end
  
  context "follow" do
    it "can follow another user" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "Bob")

      user1.follow(user2)

      user1.reload
      expect(user1.followings.size).to eq(1)
      expect(user1.followings[0].id).to eq(user2.id)
    end
  end

  context "unfollow" do
    it "can unfollow another user" do
      user1 = User.create!(name: "Alice")
      user2 = User.create!(name: "Bob")

      user1.follow(user2)
      user1.unfollow(user2)

      user1.reload
      expect(user1.followings.size).to eq(0)
    end
  end
end
