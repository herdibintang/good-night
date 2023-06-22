require "interactor"

class UserUnfollowAnotherUserUseCase
  include Interactor

  def call
    user = UserGateway.find(context.user_id)

    user_entity = UserEntity.new
    user_entity.id = user.id
    user_entity.name = user.name

    user.followings.each do |following|
      follow_user = UserEntity.new
      follow_user.id = following.id
      follow_user.name = following.name

      user_entity.followings << follow_user
    end

    unfollow_user = UserGateway.find(context.unfollow_user_id)

    unfollow_user_entity = UserEntity.new
    unfollow_user_entity.id = unfollow_user.id
    unfollow_user_entity.name = unfollow_user.name

    if !user_entity.unfollow(unfollow_user_entity)
      context.fail!(error: "Not following this user")
    end

    UserGateway.refresh_followings(user_entity)
  end
end