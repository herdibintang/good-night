require 'spec_helper'
require_relative '../../app/use_cases/user_end_sleep_use_case'

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
    sleep_gateway = double("sleep_gateway")
    allow(sleep_gateway).to receive(:find_all_by_user_id) {
      [
        {
          start_at: DateTime.parse("2023-06-10 20:00:00"),
          end_at: DateTime.parse("2023-06-10 21:00:00"),
          duration_in_second: 3600
        }
      ]
    }

    datetime = "2023-06-10 21:59:59"

    result = UserEndSleepUseCase.call(
      sleep_gateway: sleep_gateway,
      user_id: 1,
      datetime: datetime
    )
    
    expect(result.success?).to eq(false)
  end
end