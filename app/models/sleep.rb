class Sleep < ApplicationRecord
  belongs_to :user

  def clock_out=(value)
    super(value)

    if self.clock_out.present?
      self.duration_in_second = self.clock_out - self.clock_in
    end
  end
end
