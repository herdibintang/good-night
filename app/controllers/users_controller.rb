class UsersController < ApplicationController
  def create
    result = CreateUserUseCase.call(name: params.require(:name))

    @user = result.user
  end

  def index
    result = ViewUsersUseCase.call()

    @users = result.users
  end

  def destroy
    User.destroy(params[:id])
  end

  def sleeps_start
    result = UserStartSleepUseCase.call(
      user_id: params[:id],
      datetime: params.require(:datetime)
    )

    if result.failure?
      if result.error[:code] == :not_found
        render json: { error: result.error[:message] }, status: :not_found
      else
        render json: { error: result.error }, status: :unprocessable_entity
      end
    end

    @sleep = result.sleep
  end

  def sleeps_end
    result = UserEndSleepUseCase.call(
      user_id: params[:id],
      datetime: params.require(:datetime)
    )

    if result.failure?
      render json: { error: result.error }, status: :unprocessable_entity
    end

    @sleep = result.sleep
  end

  def follow
    UserFollowAnotherUserUseCase.call(
      user_id: params[:id],
      follow_user_id: params.require(:user_id)
    )
  end

  def unfollow
    result = UserUnfollowAnotherUserUseCase.call(
      user_id: params[:id],
      unfollow_user_id: params.require(:user_id)
    )

    if result.failure?
      return render json: { error: "Not following this user" }, status: :conflict
    end
  end

  def followings_sleeps
    result = UserViewFollowingsSleepsUseCase.call(
      user_id: params[:id]
    )

    @sleeps = result.sleeps
  end

  def sleeps
    result = UserViewSleepsUseCase.call(
      user_id: params[:id]
    )

    @sleeps = result.sleeps
  end

  def followings
    result = UserViewFollowingsUseCase.call(
      user_id: params[:id]
    )

    @followings = result.followings
  end

  private
end
