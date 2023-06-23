class UsersController < ApplicationController
  def create
    @user = User.create!(name: params.require(:name))
  end

  def index
    @users = User.all
  end

  def sleeps_start
    @sleep = User.find(params[:id]).clock_in(params.require(:datetime))
  end

  def sleeps_end
    user = User.find(params[:id])
    user.clock_out(params.require(:datetime))

    @sleep = user.sleeps.last
  end

  def follow
    user = User.find(params[:id]).follow(User.find(params.require(:user_id)))

    render json: { message: "Follow success" }
  end

  def unfollow
    user = User.find(params[:id])
    
    if !user.followings.include?(User.find(params.require(:user_id)))
      return render json: { error: "Not following this user" }, status: :conflict
    end

    user.unfollow(User.find(params.require(:user_id)))

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
