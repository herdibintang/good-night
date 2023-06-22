require 'rails_helper'

describe UserFollowAnotherUserUseCase do
  it 'success' do
    user1 = User.create!(name: "Alice")
    user2 = User.create!(name: "Bob")

    result = UserFollowAnotherUserUseCase.call(
      user_id: user1.id,
      follow_user_id: user2.id
    )
    
    user1.reload
    expect(user1.followings.size).to eq(1)
    expect(user1.followings[0].id).to eq(user2.id)
  end
end