require 'rails_helper'

describe UserEndSleepUseCase do
  it 'success' do
    user = User.create!(name: "Alice")

    Sleep.insert_all([
      {
        user_id: user.id,
        start_at: "2023-06-10 20:00:00",
        end_at: "2023-06-10 21:00:00"
      },
      {
        user_id: user.id,
        start_at: "2023-06-20 20:59:59",
        end_at: nil
      }
    ])

    datetime = "2023-06-20 21:59:59"

    result = UserEndSleepUseCase.call(
      sleep_gateway: SleepGateway,
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(true)
    expect(user.sleeps[0].start_at.strftime("%F %T")).to eq("2023-06-10 20:00:00")
    expect(user.sleeps[0].end_at.strftime("%F %T")).to eq("2023-06-10 21:00:00")
    expect(user.sleeps[1].end_at.strftime("%F %T")).to eq(datetime)
    expect(user.sleeps[1].duration_in_second).to eq(3600)
  end

  it 'cannot end sleep if datetime is before start sleep' do
    user = User.create!(name: "Alice")

    Sleep.insert_all([
      {
        user_id: user.id,
        start_at: "2023-06-20 20:59:59",
        end_at: nil
      }
    ])

    datetime = "2023-06-10 21:59:59"

    result = UserEndSleepUseCase.call(
      sleep_gateway: SleepGateway,
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(false)
  end
end