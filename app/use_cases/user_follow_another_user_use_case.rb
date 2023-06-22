require "interactor"

class UserFollowAnotherUserUseCase
  include Interactor

  def call
    User.find(context.follow_user_id)

    user_entity = UserEntity.new
    user_entity.id = context.user_id

    follow_user_entity = UserEntity.new
    follow_user_entity.id = context.follow_user_id

    user_entity.follow(follow_user_entity)

    user_entity.followings.each do |following|
      Follow.create!(
        from_user_id: user_entity.id,
        to_user_id: follow_user_entity.id
      )
    end
  end
end