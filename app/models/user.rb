class User < ApplicationRecord
  has_many :sleeps
  has_many :follows, foreign_key: :from_user_id, class_name: "Follow"
  has_many :followings, through: :follows, source: :to_user

  def clock_in(time)
    last_sleep = sleeps.last
    
    if last_sleep.present? && last_sleep.clock_out.nil?
      errors.add(:base, "Cannot clock in if there is a clock in without clock out")
      return
    end

    sleeps.create!(clock_in: time)
  end

  def clock_out(time)
    last_sleep = sleeps.last
    
    if last_sleep.nil?
      errors.add(:base, "Cannot clock out without previous clock in")
      return
    end
    
    last_sleep.update!(clock_out: time)
  end

  def follow(user)
    followings << user
  end
end