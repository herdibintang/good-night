require "interactor"

class UserEndSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    
    sleeps = SleepGateway.find_all_by_user_id(context.user_id)

    user_entity.add_sleeps_from_hashes(sleeps)
    
    sleep = user_entity.end_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    sleep_hash = {
      id: sleep.id,
      start_at: sleep.start_at,
      end_at: sleep.end_at,
      duration_in_second: sleep.duration_in_second
    }

    SleepGateway.update(sleep_hash)

    context.sleep = sleep_hash
  end

  private
end