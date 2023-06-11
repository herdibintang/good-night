class Sleep < ApplicationRecord
  belongs_to :user

  def clock_out=(value)
    super(value)
    self.duration_in_second = self.clock_out - self.clock_in    
  end
end
