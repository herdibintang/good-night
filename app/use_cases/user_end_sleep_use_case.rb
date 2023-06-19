require "interactor"

class UserEndSleepUseCase
  include Interactor

  def call
    User.find(context.user_id).clock_out(context.datetime)
  end
end