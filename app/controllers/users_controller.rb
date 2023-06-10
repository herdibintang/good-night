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

  private
end
