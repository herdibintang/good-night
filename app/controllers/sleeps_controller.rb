class SleepsController < ApplicationController
  def index
    # @sleeps = Sleep.includes(:user).order(created_at: :desc)

    result = ViewSleepsUseCase.call

    @sleeps = result.sleeps
  end
end
