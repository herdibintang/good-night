class UsersController < ApplicationController
  def clock_in
    begin
      user = User.find(params[:id]).clock_in(params.require(:datetime))

      render json: { message: "Clock in success" }
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private
end
