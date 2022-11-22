# frozen_string_literal: true

class UsersController < ApplicationController
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, only: %i[id login], status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:login, :password)
  end
end
