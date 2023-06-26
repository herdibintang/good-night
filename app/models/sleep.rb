class Sleep < ApplicationRecord
  validate :end_at_cannot_be_less_then_start_at

  belongs_to :user

  scope :last_week, -> { where({ start_at: Date.today.last_week.beginning_of_week..Date.today.last_week.at_end_of_week }) }

  def end_at=(value)
    super(value)

    if self.end_at.present?
      self.duration_in_second = self.end_at - self.start_at
    end
  end

  private

  def end_at_cannot_be_less_then_start_at
    if end_at.present? && end_at < start_at
      errors.add(:end_at, "cannot be less than start at")
    end
  end
end
