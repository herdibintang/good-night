class User < ApplicationRecord
  has_many :sleeps

  def clock_in(time)
    self.sleeps.create!(clock_in: time)
  end

  def clock_out(time)
    self.sleeps.create!(clock_out: time)
  end
end
