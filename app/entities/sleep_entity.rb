class SleepEntity
  include ActiveModel::Validations
  
  attr_accessor :start_at, :end_at
  
  def initialize(start_at:)
    @start_at = start_at
  end

  def ongoing?
    @end_at.nil?
  end
end