require 'rails_helper'

describe UserStartSleepUseCase do
  it 'success' do
    user = User.create!(name: "Alice")

    datetime = "2023-06-20 21:59:59"

    result = UserStartSleepUseCase.call(
      user_id: user.id,
      datetime: datetime
    )
    
    expect(result.success?).to eq(true)
    expect(user.sleeps[0].clock_in.strftime("%F %T")).to eq(datetime)
  end
end