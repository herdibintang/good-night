require 'rails_helper'

describe UserEndSleepUseCase do
  it 'success' do
    user = User.create!(name: "Alice")
    user.clock_in("2023-06-20 20:59:59")

    datetime = "2023-06-20 21:59:59"

    result = UserEndSleepUseCase.call(
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(true)
    expect(user.sleeps[0].clock_out.strftime("%F %T")).to eq(datetime)
    expect(user.sleeps[0].duration_in_second).to eq(3600)
  end
end