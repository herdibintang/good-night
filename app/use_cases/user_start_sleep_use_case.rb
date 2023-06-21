require "interactor"

class UserStartSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    
    Sleep.where(user_id: context.user_id).all.each do |sleep|
      sleep_entity = SleepEntity.new
      sleep_entity.id = sleep.id
      sleep_entity.start_at = sleep.clock_in
      sleep_entity.end_at = sleep.clock_out
      
      user_entity.sleeps << sleep_entity
    end
    
    user_entity.start_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    user_entity.sleeps.each do |sleep|
      if sleep.changed?
        Sleep.create!(user_id: context.user_id, clock_in: sleep.start_at)
      end
    end
  end
end