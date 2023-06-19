require 'rails_helper'

describe UserEntity do
  it 'start_sleep' do
    user = UserEntity.new
    user.start_sleep("2023-06-20 21:00:00")
    
    expect(user.sleeps[0].start_at).to eq("2023-06-20 21:00:00")
  end
end