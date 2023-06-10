class User < ApplicationRecord
  has_many :sleeps

  def clock_in(time)
    self.sleeps.create!(clock_in: time)
  end
end
