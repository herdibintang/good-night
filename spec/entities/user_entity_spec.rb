require 'rails_helper'

describe UserEntity do
  it 'can start sleep' do
    user = UserEntity.new
    user.start_sleep("2023-06-20 21:00:00")
    
    expect(user.sleeps[0].start_at).to eq("2023-06-20 21:00:00")
  end

  it 'can end sleep' do
    datetime_start = "2023-06-20 21:00:00"
    datetime_end = "2023-06-20 22:00:00"

    user = UserEntity.new
    user.start_sleep(datetime_start)
    user.end_sleep(datetime_end)
    
    expect(user.sleeps[0].start_at).to eq(datetime_start)
    expect(user.sleeps[0].end_at).to eq(datetime_end)
  end

  it 'cannot end sleep if there is no ongoing sleep' do
    datetime = "2023-06-20 22:00:00"

    user = UserEntity.new
    user.end_sleep(datetime)
    
    expect(user.valid?).to eq(false)
  end
end