class SleepEntity
  include ActiveModel::Validations
  include ActiveModel::Dirty
  
  attr_accessor :id, :start_at, :end_at
  define_attribute_methods :end_at
  
  attr_accessor :start_at, :end_at
  
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
end