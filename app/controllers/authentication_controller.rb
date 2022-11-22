# frozen_string_literal: true

class AuthenticationController < ApplicationController
  include JsonWebToken
  before_action :find_user

  # POST /login
  def login
    if @user&.authenticate(params[:login][:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 1.hours.to_i
      render json: { token:, exp: time.strftime('%m-%d-%Y %H:%M') }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def find_user
    @user = User.find_by_login(params[:login][:login])
  end

  def login_params
    params.require(:login).permit(:login, :password)
  end
end
