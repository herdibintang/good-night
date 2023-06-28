require 'rails_helper'

describe ViewSleepsUseCase do
  it 'success' do
    user1 = User.create!(name: "Alice")
    user1.sleeps.create!(
      start_at: "2023-05-20 20:00:00",
      end_at: "2023-05-20 21:00:00",
      duration_in_second: 3600,
      created_at: 2.hour.ago
    )

    user2 = User.create!(name: "Bob")
    user2.sleeps.create!(
      start_at: "2023-05-21 23:00:00",
      end_at: nil,
      duration_in_second: nil,
      created_at: 1.hour.ago
    )

    result = ViewSleepsUseCase.call
    
    expect(result.success?).to eq(true)
    
    expect(result.sleeps[0][:start_at].strftime("%F %T")).to eq("2023-05-21 23:00:00")
    expect(result.sleeps[0][:end_at]).to eq(nil)
    expect(result.sleeps[0][:duration_in_second]).to eq(nil)
    expect(result.sleeps[0][:user][:name]).to eq("Bob")

    expect(result.sleeps[1][:start_at].strftime("%F %T")).to eq("2023-05-20 20:00:00")
    expect(result.sleeps[1][:end_at].strftime("%F %T")).to eq("2023-05-20 21:00:00")
    expect(result.sleeps[1][:duration_in_second]).to eq(3600)
    expect(result.sleeps[1][:user][:name]).to eq("Alice")
  end
end