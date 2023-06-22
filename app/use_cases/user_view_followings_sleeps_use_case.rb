require "interactor"

class UserViewFollowingsSleepsUseCase
  include Interactor

  def call
    context.sleeps = Sleep.last_week
      .includes(:user)
      .joins(user: :followed)
      .where(follows: { from_user_id: context.user_id })
      .order(duration_in_second: :desc)
  end
end