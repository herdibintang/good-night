require "interactor"

class UserEndSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    SleepGateway.find_all_by_user_id(context.user_id).each do |sleep|
      sleep_entity = SleepEntity.new
      sleep_entity.id = sleep[:id]
      sleep_entity.start_at = sleep[:start_at]
      sleep_entity.end_at = sleep[:end_at]
      
      user_entity.sleeps << sleep_entity
    end
    
    user_entity.end_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    user_entity.sleeps.each do |sleep|
      if sleep.changed?
        Sleep.find(sleep.id).update!(clock_out: sleep.end_at)
      end
    end
  end
end