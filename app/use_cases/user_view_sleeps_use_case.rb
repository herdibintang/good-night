require "interactor"

class UserViewSleepsUseCase
  include Interactor

  def call
    context.sleeps = User.find(context.user_id)
      .sleeps
      .order(created_at: :desc)
  end
end