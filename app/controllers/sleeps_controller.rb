class SleepsController < ApplicationController
  def index
    data = Sleep.order(created_at: :desc).map { |sleep|
      {
        clock_in: sleep.clock_in.strftime("%F %T"),
        clock_out: sleep.clock_out.try(:strftime, "%F %T"),
        duration_in_second: sleep.duration_in_second
      }
    }

    render json: { data: data }
  end
end
