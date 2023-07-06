require "interactor"
require_relative "../entities/user_entity"

class UserEndSleepUseCase
  include Interactor

  def call
    user_entity = UserEntity.new
    
    sleeps = context.sleep_gateway.find_all_by_user_id(context.user_id)

    user_entity.add_sleeps_from_hashes(sleeps)
    
    sleep = user_entity.end_sleep(context.datetime)

    unless user_entity.valid?
      context.fail!(error: user_entity.errors.full_messages.to_sentence)
    end

    context.sleep_gateway.update(sleep.to_hash)

    context.sleep = sleep.to_hash
  end

  private
end