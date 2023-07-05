require 'active_model'

class SleepEntity
  include ActiveModel::Validations
  include ActiveModel::Dirty
  
  attr_accessor :id, :start_at, :end_at
  attr_reader :duration_in_second
  define_attribute_methods :start_at, :end_at

  validate :end_at_cannot_be_before_start_at
  validate :end_at_invalid
  
  def ongoing?
    @end_at.nil?
  end

  def start_at=(value)
    start_at_will_change!

    if value.nil?
      @start_at = nil
    elsif value.class == DateTime
      @start_at = value
    else
      @start_at = DateTime.parse(value)
    end
  end

  def end_at=(value)
    end_at_will_change!

    if value.nil?
      @end_at = nil
    elsif value.class == DateTime
      @end_at = value
    else
      @end_at = DateTime.parse(value)
    end

    if @end_at.present? && @start_at.present?
      @duration_in_second = ((@end_at - @start_at.to_datetime) * 24 * 60 * 60).to_i
    end
  end

  def end_at_cannot_be_before_start_at
    if end_at.present? && start_at.present? && end_at < start_at
      errors.add(:end_at, "cannot be before start at")
    end
  end

  def end_at_invalid
    if end_at.present? && start_at.nil?
      errors.add(:sleep, "invalid")
    end
  end

  def eq?(another_sleep)
    start_at == another_sleep.start_at && end_at == another_sleep.end_at
  end

  def to_hash
    {
      id: @id,
      start_at: @start_at,
      end_at: @end_at,
      duration_in_second: @duration_in_second,
    }
  end
end