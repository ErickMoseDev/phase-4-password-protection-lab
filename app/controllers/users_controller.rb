class UsersController < ApplicationController
  before_action :authorize, only: [:show]

  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    user = User.find_by(id: session[:user_id])
    render json: user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def invalid_record(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end
end
