require 'rails_helper'

describe UserEndSleepUseCase do
  it 'success' do
    sleep_gateway = double("sleep_gateway")
    allow(sleep_gateway).to receive(:find_all_by_user_id) {
      [
        {
          start_at: DateTime.parse("2023-06-10 20:00:00"),
          end_at: DateTime.parse("2023-06-10 21:00:00"),
          duration_in_second: 3600
        },
        {
          start_at: DateTime.parse("2023-06-20 20:59:59"),
          end_at: nil,
          duration_in_second: nil
        }
      ]
    }
    allow(sleep_gateway).to receive(:update)

    datetime = "2023-06-20 21:59:59"

    result = UserEndSleepUseCase.call(
      sleep_gateway: sleep_gateway,
      user_id: 1,
      datetime: datetime
    )

    expect(result.success?).to eq(true)
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