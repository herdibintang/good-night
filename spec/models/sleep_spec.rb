require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it "automatically set duration_in_seconds when clock out is updated" do
    user = User.new

    sleep = Sleep.new
    sleep.clock_in = "2023-05-20 20:00:00"
    sleep.clock_out = "2023-05-20 21:00:00"
    sleep.user = user
    sleep.save!

    sleep.reload
    expect(sleep.duration_in_second).to eq(3600)
  end
end
