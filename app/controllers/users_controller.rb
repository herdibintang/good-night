class UsersController < ApplicationController
  def create
    @user = User.create!(name: params.require(:name))
  end

  def index
    @users = User.all
  end

  def clock_in
    user = User.find(params[:id]).clock_in(params.require(:datetime))

    render json: { message: "Clock in success" }
  end

  def clock_out
    user = User.find(params[:id]).clock_out(params.require(:datetime))

    render json: { message: "Clock out success" }
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
    @sleeps = Sleep.includes(:user)
      .joins(user: :followed)
      .where(follows: { from_user_id: params[:id] })
      .where({ clock_in: Date.today.last_week.beginning_of_week..Date.today.last_week.at_end_of_week })
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
