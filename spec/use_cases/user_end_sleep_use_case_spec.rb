require 'rails_helper'

describe UserEndSleepUseCase do
  it 'success' do
    user = User.create!(name: "Alice")

    Sleep.insert_all([
      {
        user_id: user.id,
        clock_in: "2023-06-10 20:00:00",
        clock_out: "2023-06-10 21:00:00"
      },
      {
        user_id: user.id,
        clock_in: "2023-06-20 20:59:59",
        clock_out: nil
      }
    ])

    datetime = "2023-06-20 21:59:59"

    result = UserEndSleepUseCase.call(
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(true)
    expect(user.sleeps[0].clock_in.strftime("%F %T")).to eq("2023-06-10 20:00:00")
    expect(user.sleeps[0].clock_out.strftime("%F %T")).to eq("2023-06-10 21:00:00")
    expect(user.sleeps[1].clock_out.strftime("%F %T")).to eq(datetime)
    expect(user.sleeps[1].duration_in_second).to eq(3600)
  end

  it 'cannot end sleep if datetime is before start sleep' do
    user = User.create!(name: "Alice")

    Sleep.insert_all([
      {
        user_id: user.id,
        clock_in: "2023-06-20 20:59:59",
        clock_out: nil
      }
    ])

    datetime = "2023-06-10 21:59:59"

    result = UserEndSleepUseCase.call(
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(false)
  end
end