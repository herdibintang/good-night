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

    time = "2023-06-20 21:59:59"

    user.clock_out(time)

    expect(user.sleeps[0].clock_out.strftime("%F %T")).to eq(time)
  end
end
