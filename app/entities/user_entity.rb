class UserEntity
  include ActiveModel::Validations

  attr_accessor :id, :sleeps, :followings

  validate :sleeps_valid

  def initialize
    @sleeps = []
    @followings = []
  end

  def start_sleep(datetime)
    sleep_entity = SleepEntity.new
    sleep_entity.start_at = datetime

    @sleeps << sleep_entity
  end

  def end_sleep(datetime)
    sleep = @sleeps.find { |h| h.ongoing? }

    if sleep.nil?
      sleep = SleepEntity.new
      sleep.end_at = datetime

      @sleeps << sleep
    else
      sleep.end_at = datetime
    end
  end

  def follow(user)
    @followings << user
  end

  private
  def sleeps_valid
    if @sleeps.any? { |sleep| !sleep.valid? }
      errors.add(:sleeps, "invalid")
    end
  end
end