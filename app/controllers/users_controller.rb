class UsersController < ApplicationController
  def create
    user = User.create!(name: params.require(:name))

    render json: {
      message: "Create user success",
      data: {
        id: user.id,
        name: user.name
      }
    }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  end

  def index
    data = User.all.map { |user|
      {
        id: user.id,
        name: user.name
      }
    }

    render json: { data: data }
  end

  def clock_in
    user = User.find(params[:id]).clock_in(params.require(:datetime))

    render json: { message: "Clock in success" }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def clock_out
    user = User.find(params[:id]).clock_out(params.require(:datetime))

    render json: { message: "Clock out success" }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def follow
    user = User.find(params[:id]).follow(User.find(params.require(:user_id)))

    render json: { message: "Follow success" }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def unfollow
    user = User.find(params[:id])
    
    if !user.followings.include?(User.find(params.require(:user_id)))
      return render json: { error: "Not following this user" }, status: :conflict
    end

    user.unfollow(User.find(params.require(:user_id)))

    render json: { message: "Unfollow success" }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def followings_sleeps
    data = Sleep.includes(:user)
      .joins(user: :followed)
      .where(follows: { from_user_id: params[:id] })
      .where({ clock_in: Date.today.last_week.beginning_of_week..Date.today.last_week.at_end_of_week })
      .order(duration_in_second: :desc)
      .map { |sleep|
        {
          clock_in: sleep.clock_in.strftime("%F %T"),
          clock_out: sleep.clock_out.try(:strftime, "%F %T"),
          duration_in_second: sleep.duration_in_second,
          user: {
            name: sleep.user.name
          }
        }
      }

    render json: { data: data }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def sleeps
    data = User.includes(:sleeps)
      .find(params[:id])
      .sleeps
      .order(created_at: :desc)
      .map { |sleep|
        {
          clock_in: sleep.clock_in.strftime("%F %T"),
          clock_out: sleep.clock_out.try(:strftime, "%F %T"),
          duration_in_second: sleep.duration_in_second
        }
      }

    render json: { data: data }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :conflict
  end

  def followings
    data = User.find(params[:id]).followings.map { |following|
      {
        id: following.id,
        name: following.name
      }
    }

    render json: { data: data }
  end

  private
end
