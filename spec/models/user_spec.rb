require 'rails_helper'

RSpec.describe User, type: :model do
  it "can do clock in" do
    user = User.create!

    time = "2023-06-20 21:59:59"

    user.clock_in(time)

    expect(user.sleeps[0].clock_in.strftime("%F %T")).to eq(time)
  end

  it "can do clock out" do
    user = User.create!
    user.clock_in("2023-06-20 21:59:59")

    time = "2023-06-20 21:59:59"

    user.clock_out(time)

    expect(user.sleeps[0].clock_out.strftime("%F %T")).to eq(time)
  end

  it "cannot do clock out if there is no previous check in" do
    user = User.create!

    time = "2023-06-20 21:59:59"

    user.clock_out(time)

    expect(user.errors.size).not_to eq(0)
    expect(user.sleeps.last).to eq(nil)
    expect(user.errors.full_messages).to include("Cannot clock out without previous clock in")
  end

  it "cannot do clock in if there is a clock in without clock out" do
    user = User.create!
    time = "2023-06-20 21:59:59"
    user.sleeps.create!(clock_in: time)

    user.clock_in(time)

    expect(user.errors.size).not_to eq(0)
    expect(user.sleeps.size).to eq(1)
    expect(user.errors.full_messages).to include("Cannot clock in if there is a clock in without clock out")
  end
end
