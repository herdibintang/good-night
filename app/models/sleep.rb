class Sleep < ApplicationRecord
  validate :clock_out_cannot_be_less_then_clock_in

  belongs_to :user

  scope :last_week, -> { where({ clock_in: Date.today.last_week.beginning_of_week..Date.today.last_week.at_end_of_week }) }

  def clock_out=(value)
    super(value)

    if self.clock_out.present?
      self.duration_in_second = self.clock_out - self.clock_in
    end
  end

  private

  def clock_out_cannot_be_less_then_clock_in
    if clock_out.present? && clock_out < clock_in
      errors.add(:clock_out, "cannot be less than clock in")
    end
  end

end
