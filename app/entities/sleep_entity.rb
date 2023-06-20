class SleepEntity
  include ActiveModel::Validations
  include ActiveModel::Dirty
  
  attr_accessor :id, :start_at, :end_at
  define_attribute_methods :end_at

  validate :end_at_cannot_be_before_start_at
  
  def initialize(start_at:)
    @start_at = start_at
  end

  def ongoing?
    @end_at.nil?
  end

  def end_at=(value)
    end_at_will_change!
    @end_at = value
  end

  def end_at_cannot_be_before_start_at
    if end_at < start_at
      errors.add(:end_at, "cannot be before start at")
    end
  end
end