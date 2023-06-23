require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it "cannot have clock out that less than clock in" do
    sleep = Sleep.new
    sleep.start_at = "2023-05-20 20:00:00"
    sleep.end_at = "2023-05-18 21:00:00"
    
    expect(sleep).not_to be_valid
    expect(sleep.errors.full_messages).to include("End at cannot be less than clock in")
  end

  it "automatically set duration_in_seconds when clock out is updated" do
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
