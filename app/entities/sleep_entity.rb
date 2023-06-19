class SleepEntity
  include ActiveModel::Validations
  
  attr_accessor :start_at
  
  def initialize(start_at:)
    @start_at = start_at
  end
end