# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    side { 1 }
    quantity { 1.5 }
    stock_price_id {}
    user_id {}
  end
end
