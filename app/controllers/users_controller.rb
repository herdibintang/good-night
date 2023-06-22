class UsersController < ApplicationController
  def create
    @user = User.create!(name: params.require(:name))
  end

  def index
    @users = User.all
  end

  def clock_in
    result = UserStartSleepUseCase.call(
      user_id: params[:id],
      datetime: params.require(:datetime)
    )

    if result.success?
      render json: { message: "Clock in success" }
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
    @sleeps = Sleep.last_week
      .includes(:user)
      .joins(user: :followed)
      .where(follows: { from_user_id: params[:id] })
      .order(duration_in_second: :desc)
  end

  def sleeps
    @sleeps = User.find(params[:id])
      .sleeps
      .order(created_at: :desc)
  end

  def followings
    @followings = User.find(params[:id]).followings
  end

  private
end
