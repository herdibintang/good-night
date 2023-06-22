require "interactor"

class UserViewFollowingsUseCase
  include Interactor

  def call
    context.followings = UserGateway.find_followings_by_user_id(context.user_id)
  end
end