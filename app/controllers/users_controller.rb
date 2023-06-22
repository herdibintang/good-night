class UsersController < ApplicationController
  def create
    result = CreateUserUseCase.call(name: params.require(:name))

    @user = result.user
  end

  def index
    result = ViewUsersUseCase.call()

    @users = result.users
  end

  def clock_in
    result = UserStartSleepUseCase.call(
      user_id: params[:id],
      datetime: params.require(:datetime)
    )

    if result.success?
      render json: { message: "Clock in success" }
    elsif result.error[:code] == :not_found
      render json: { error: result.error[:message] }, status: :not_found
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  def clock_out
    result = UserEndSleepUseCase.call(
      user_id: params[:id],
      datetime: params.require(:datetime)
    )

    if result.success?
      render json: { message: "Clock out success" }
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  def follow
    result = UserFollowAnotherUserUseCase.call(
      user_id: params[:id],
      follow_user_id: params.require(:user_id)
    )

    render json: { message: "Follow success" }
  end

  def unfollow
    result = UserUnfollowAnotherUserUseCase.call(
      user_id: params[:id],
      unfollow_user_id: params.require(:user_id)
    )

    if result.failure?
      return render json: { error: "Not following this user" }, status: :conflict
    end

    render json: { message: "Unfollow success" }
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
