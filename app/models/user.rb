class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleeps
  has_many :follows, foreign_key: :from_user_id, class_name: "Follow"
  has_many :followed, foreign_key: :to_user_id, class_name: "Follow"
  has_many :followings, through: :follows, source: :to_user

  def start_sleep(time)
    last_sleep = sleeps.last
    
    if last_sleep.present? && last_sleep.end_at.nil?
      errors.add(:base, "Cannot start sleep if there is a start sleep without end sleep")
      return
    end

    sleeps.create!(start_at: time)
  end

  def end_sleep(time)
    last_sleep = sleeps.last
    
    if last_sleep.nil?
      errors.add(:base, "Cannot end sleep without previous start sleep")
      return
    end
    
    last_sleep.update!(end_at: time)
  end

  def follow(user)
    followings << user
  end

  def unfollow(user)
    followings.delete(user)
  end
end
