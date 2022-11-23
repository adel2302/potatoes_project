# frozen_string_literal: true

class StockPricesController < ApplicationController
  before_action :authorize_request
  before_action :day
  before_action :check_format

  def search
    stock_prices = StockPrice.by_date(@day).as_json
    if stock_prices.present?
      render json: stock_prices, status: :ok
    else
      render json: { message: 'Data unavailable for this day' }, status: :ok
    end
  end

  def simulation
    render json: StockPrice.gain(@day), status: :ok
  end

  private

  def day
    @day = params[:stock_price][:day]
  end

  def check_format
    Date.parse(@day) if @day.present?
  rescue Date::Error
    render json: { error: 'Format must be dd/mm/yyyy' },
           status: :unprocessable_entity
  end
end
