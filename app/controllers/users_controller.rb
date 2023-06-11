class UsersController < ApplicationController
  def clock_in
    begin
      user = User.find(params[:id]).clock_in(params.require(:datetime))

      render json: { message: "Clock in success" }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def clock_out
    begin
      user = User.find(params[:id]).clock_out(params.require(:datetime))

      render json: { message: "Clock out success" }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def follow
    begin
      user = User.find(params[:id]).follow(User.find(params.require(:user_id)))

      render json: { message: "Follow success" }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def unfollow
    begin
      user = User.find(params[:id]).unfollow(User.find(params.require(:user_id)))

      render json: { message: "Unfollow success" }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def followings_sleeps
    begin
      data = Sleep.includes(:user)
        .joins(user: :followed)
        .where(follows: { from_user_id: params[:id] })
        .where({ clock_in: Date.today.last_week.beginning_of_week..Date.today.last_week.at_end_of_week })
        .order(duration_in_second: :desc)
        .map { |sleep|
          {
            name: sleep.user.name,
            clock_in: sleep.clock_in.strftime("%F %T"),
            clock_out: sleep.clock_out.strftime("%F %T"),
            duration_in_second: sleep.duration_in_second
          }
        }

      render json: { data: data }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private
end
