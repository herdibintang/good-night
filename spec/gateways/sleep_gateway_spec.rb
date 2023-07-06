require 'rails_helper'

describe SleepGateway do
  it 'can return all sleeps created desc' do
    user = User.create!(name: "Alice")
    sleep1 = Sleep.create!(
      user_id: user.id,
      start_at: "2023-06-10 20:00:00",
      end_at: "2023-06-10 21:00:00",
      duration_in_second: 3600,
      created_at: 2.hours.ago
    )
    sleep2 = Sleep.create!(
      user_id: user.id,
      start_at: "2023-06-20 20:00:00",
      end_at: nil,
      duration_in_second: nil,
      created_at: 1.hours.ago
    )

    sleeps = SleepGateway.find_all()

    expect(sleeps[0][:id]).to eq(sleep2.id)

    expect(sleeps[1][:id]).to eq(sleep1.id)
    expect(sleeps[1][:user_id]).to eq(user.id)
    expect(sleeps[1][:start_at]).to eq("2023-06-10 20:00:00")
    expect(sleeps[1][:end_at]).to eq("2023-06-10 21:00:00")
    expect(sleeps[1][:duration_in_second]).to eq(3600)
  end

  it 'can update' do
    user = User.create!(name: "Alice")
    
    sleep = Sleep.create!(
      user_id: user.id,
      start_at: "2023-06-20 20:00:00",
      end_at: nil,
      duration_in_second: nil,
      created_at: 1.hours.ago
    )

    SleepGateway.update({
      id: sleep.id,
      start_at: DateTime.parse("2023-06-10 19:00:00"),
      end_at: DateTime.parse("2023-06-10 19:45:00"),
      duration_in_second: 2700
    })

    sleep.reload
    expect(sleep.start_at).to eq("2023-06-10 19:00:00")
    expect(sleep.end_at).to eq("2023-06-10 19:45:00")
    expect(sleep.duration_in_second).to eq(2700)
  end

  it 'can return all sleeps by user id' do
    user1 = User.create!(name: "Alice")
    sleep1 = Sleep.create!(
      user_id: user1.id,
      start_at: "2023-06-10 20:00:00",
      end_at: "2023-06-10 21:00:00",
      duration_in_second: 3600,
      created_at: 2.hours.ago
    )

    user2 = User.create!(name: "Bob")
    sleep2 = Sleep.create!(
      user_id: user2.id,
      start_at: "2023-06-20 20:00:00",
      end_at: nil,
      duration_in_second: nil,
      created_at: 1.hours.ago
    )

    sleeps = SleepGateway.find_all_by_user_id(user1.id)

    expect(sleeps.size).to eq(1)

    expect(sleeps[0][:id]).to eq(sleep1.id)
    expect(sleeps[0][:start_at]).to eq("2023-06-10 20:00:00")
    expect(sleeps[0][:end_at]).to eq("2023-06-10 21:00:00")
    expect(sleeps[0][:duration_in_second]).to eq(3600)
  end
end