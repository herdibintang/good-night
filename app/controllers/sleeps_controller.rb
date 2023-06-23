class SleepsController < ApplicationController
  def index
    data = Sleep.includes(:user).order(created_at: :desc).map { |sleep|
      {
        start_at: sleep.start_at.strftime("%F %T"),
        end_at: sleep.end_at.try(:strftime, "%F %T"),
        duration_in_second: sleep.duration_in_second,
        user: {
          name: sleep.user.name
        }
      }
    }

    render json: { data: data }
  end
end
