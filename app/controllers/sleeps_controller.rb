class SleepsController < ApplicationController
  def index
    @sleeps = Sleep.includes(:user).order(created_at: :desc)
  end
end
