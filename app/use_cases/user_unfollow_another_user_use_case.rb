require "interactor"

class UserUnfollowAnotherUserUseCase
  include Interactor

  def call
    user = User.find(context.user_id)
    
    if !user.followings.include?(User.find(context.unfollow_user_id))
      context.fail!(error: "Not following this user")
    end

    user.unfollow(User.find(context.unfollow_user_id))
  end
end