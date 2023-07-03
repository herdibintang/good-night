require 'rails_helper'

describe UserEntity do
  context 'start sleep' do
    it 'can start sleep' do
      user = UserEntity.new
      user.start_sleep("2023-06-20 21:00:00")
      
      expect(user.sleeps[0].start_at).to eq("2023-06-20 21:00:00")
    end
  end

  context 'end sleep' do
    it 'can end sleep' do
      datetime_start = "2023-06-20 21:00:00"
      datetime_end = "2023-06-20 22:00:00"

      user = UserEntity.new
      user.start_sleep(datetime_start)
      user.end_sleep(datetime_end)
      
      expect(user.sleeps[0].start_at).to eq(datetime_start)
      expect(user.sleeps[0].end_at).to eq(datetime_end)
    end

    it 'cannot end sleep if there is no ongoing sleep' do
      datetime = "2023-06-20 22:00:00"

      user = UserEntity.new
      user.end_sleep(datetime)
      
      expect(user.valid?).to eq(false)
    end
  end

  context 'follow' do
    it 'can follow another user' do
      user1 = UserEntity.new
      user2 = UserEntity.new

      user1.follow(user2)
      
      expect(user1.followings[0]).to equal(user2)
    end
  end

  context 'unfollow' do
    it 'can unfollow another user' do
      user1 = UserEntity.new
      user2 = UserEntity.new

      user1.follow(user2)
      user1.unfollow(user2)
      
      expect(user1.followings).to eq([])
    end

    it 'cannot unfollow another user that is not in followings' do
      user1 = UserEntity.new
      user2 = UserEntity.new

      expect(user1.unfollow(user2)).to eq(false)
    end
  end

  it 'can add sleep from hash' do
    sleep_hash = {
      id: 1,
      start_at: "2023-06-20 20:00:00",
      end_at: "2023-06-20 21:00:00",
      duration_in_second: 3600
    }

    user = UserEntity.new
    user.add_sleep_from_hash(sleep_hash)

    sleep = SleepEntity.new
    sleep.id = sleep_hash[:id]
    sleep.start_at = sleep_hash[:start_at]
    sleep.end_at = sleep_hash[:end_at]

    expect(user.sleeps[0].eq?(sleep)).to eq(true)
  end
end