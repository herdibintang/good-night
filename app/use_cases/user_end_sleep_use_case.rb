require "interactor"

class UserEndSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    
    SleepGateway.find_all_by_user_id(context.user_id).each do |sleep|
      user_entity.add_sleep_from_hash(sleep)
    end
    
    sleep = user_entity.end_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    update_sleep(sleep)

    context.sleep = {
      id: sleep.id,
      start_at: sleep.start_at,
      end_at: sleep.end_at,
      duration_in_second: sleep.duration_in_second
    }
  end

  private
  def update_sleep(sleep)
    test = Sleep.find(sleep.id)
    test.update!(end_at: sleep.end_at)

    test
  end
end