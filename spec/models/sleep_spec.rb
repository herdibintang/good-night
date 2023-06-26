require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it "cannot have end sleep that less than start sleep" do
    sleep = Sleep.new
    sleep.start_at = "2023-05-20 20:00:00"
    sleep.end_at = "2023-05-18 21:00:00"
    
    expect(sleep).not_to be_valid
    expect(sleep.errors.full_messages).to include("End at cannot be less than start at")
  end

  it "automatically set duration_in_seconds when end sleep is updated" do
    user = User.new(name: "Alice")

    sleep = Sleep.new
    sleep.start_at = "2023-05-20 20:00:00"
    sleep.end_at = "2023-05-20 21:00:00"
    sleep.user = user
    sleep.save!

    sleep.reload
    expect(sleep.duration_in_second).to eq(3600)
  end
end
