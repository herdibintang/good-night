require 'rails_helper'

describe SleepEntity do
  it 'can set start_at' do
    datetime = "2023-06-20 21:00:00"

    sleep_entity = SleepEntity.new
    sleep_entity.start_at = datetime
    
    expect(sleep_entity.start_at).to eq(datetime)
  end
end