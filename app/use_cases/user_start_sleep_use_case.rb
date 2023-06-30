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

    user_entity.start_sleep(context.datetime)

    test = nil

    user_entity.sleeps.each do |sleep|
      if sleep.changed?
        test = Sleep.create!(user_id: context.user_id, start_at: sleep.start_at)
      end
    end

    context.sleep = test
  end
end