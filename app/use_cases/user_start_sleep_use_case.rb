require "interactor"

class UserStartSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new

    user = UserGateway.find(context.user_id)
    if user.nil?
      context.fail!(error: {
        code: :not_found,  
        message: "User not found"
      })
    end
    
    SleepGateway.find_all_by_user_id(user_id: context.user_id).each do |sleep|
      sleep_entity = SleepEntity.new
      sleep_entity.id = sleep[:id]
      sleep_entity.start_at = sleep[:clock_in]
      sleep_entity.end_at = sleep[:clock_out]
      
      user_entity.sleeps << sleep_entity
    end
    
    user_entity.start_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    test = nil

    user_entity.sleeps.each do |sleep|
      if sleep.changed?
        test = Sleep.create!(user_id: context.user_id, start_at: sleep.start_at)
      end
    end

    context.sleep = test
  end
end