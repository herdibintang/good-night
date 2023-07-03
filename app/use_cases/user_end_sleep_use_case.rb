require "interactor"

class UserEndSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    
    SleepGateway.find_all_by_user_id(context.user_id).each do |sleep|
      user_entity.add_sleep_from_hash(sleep)
    end
    
    user_entity.end_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    test = nil

    user_entity.sleeps.each do |sleep|
      if sleep.changed?
        test = Sleep.find(sleep.id)
        test2 = test
        test2.update!(end_at: sleep.end_at)
      end
    end

    context.sleep = test
  end
end