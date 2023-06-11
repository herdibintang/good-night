class SleepsController < ApplicationController
  def index
    data = Sleep.includes(:user).order(created_at: :desc).map { |sleep|
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
end
