require "interactor"

class UserViewFollowingsUseCase
  include Interactor

  def call
    context.followings = User.find(context.user_id).followings
  end
end