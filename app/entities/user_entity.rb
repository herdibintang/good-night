class UserEntity
  include ActiveModel::Validations

  attr_accessor :sleeps

  def initialize
    @sleeps = []
  end

  def start_sleep(datetime)
    @sleeps << SleepEntity.new(start_at: datetime)
  end

  def end_sleep(datetime)
    sleep = @sleeps.find { |h| h.ongoing? }
    sleep.end_at = datetime
  end
end