# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authorize_request

  def create
    @wallet = @current_user.wallets.new(wallet_params)

    if @wallet.save
      render json: @wallet, status: :created
    else
      render json: { errors: @wallet.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:currency)
  end
end
