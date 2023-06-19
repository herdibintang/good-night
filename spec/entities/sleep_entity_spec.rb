require 'rails_helper'
# require_relative '../app/entities/user_entity'
# require_relative '../app/entities/sleep_entity'

describe SleepEntity do
  it 'can start' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new(start_at: datetime)
    
    expect(sleep_entity.start_at).to eq(datetime)
  end

  it 'can end' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new(start_at: "2023-06-20 20:00:00")
    sleep_entity.end_at = datetime
    
    expect(sleep_entity.end_at).to eq(datetime)
  end

  it 'is ongoing if it does not end yet' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new(start_at: datetime)
    
    expect(sleep_entity.ongoing?).to eq(true)
  end

  it 'is not ongoing if it has ended' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new(start_at: "2023-06-20 20:00:00")
    sleep_entity.end_at = datetime
    
    expect(sleep_entity.ongoing?).to eq(false)
  end
end