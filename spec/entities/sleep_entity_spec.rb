require 'spec_helper'
require_relative '../../app/entities/sleep_entity'

describe SleepEntity do
  it 'can start' do
    datetime = DateTime.parse("2023-06-20 21:00:00")

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = datetime
    
    expect(sleep_entity.start_at).to eq(datetime)
  end

  it 'can end' do
    datetime = DateTime.parse("2023-06-20 21:00:00")

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = "2023-06-20 20:00:00"
    sleep_entity.end_at = datetime
    
    expect(sleep_entity.end_at).to eq(datetime)
  end

  it 'is ongoing if it does not end yet' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = datetime
    
    expect(sleep_entity.ongoing?).to eq(true)
  end

  it 'is not ongoing if it has ended' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = "2023-06-20 20:00:00"
    sleep_entity.end_at = datetime
    
    expect(sleep_entity.ongoing?).to eq(false)
  end

  it 'cannot have end_at that before start_at' do
    datetime = "2023-06-10 21:00:00"

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = "2023-06-20 20:00:00"
    sleep_entity.end_at = datetime
    
    expect(sleep_entity.valid?).to eq(false)
    expect(sleep_entity.errors.full_messages).to include("End at cannot be before start at")
  end

  it 'can be converted to hash' do
    id = 1
    start_at = DateTime.parse("2023-06-20 20:00:00")
    end_at = DateTime.parse("2023-06-20 21:00:00")
    duration_in_second = 3600

    sleep = SleepEntity.new
    sleep.id = id
    sleep.start_at = start_at
    sleep.end_at = end_at

    hash = sleep.to_hash()

    expect(hash[:id]).to eq(id)
    expect(hash[:start_at]).to eq(start_at)
    expect(hash[:end_at]).to eq(end_at)
    expect(hash[:duration_in_second]).to eq(duration_in_second)
  end
end