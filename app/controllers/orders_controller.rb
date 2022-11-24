# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authorize_request

  def create
    @order = @current_user.orders.new(order_params)
    @order.stock_price_id = StockPrice.last&.id

    if @order.save
      render json: @order, status: :created
    else
      render json: { errors: @order.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:side, :quantity)
  end
end
