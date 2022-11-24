# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :stock_price
  belongs_to :user
  validates :side, presence: true
  validates :quantity, presence: true
  after_validation :can_buy_today?, if: proc { errors.empty? && side_buy? }
  after_validation :can_sell?, if: proc { errors.empty? && side_sell? }
  before_save :update_user_wallet, if: proc { errors.empty? && new_record? }
  enum :side, { buy: 0, sell: 1 }, prefix: true

  private

  def can_buy_today?
    if at_max_quantity?(user_id)
      errors.add(:error, "you can't exceed 100 ton by day") # we can change message to send the quantity still available
      false
    else
      true
    end
  end

  def at_max_quantity?(user_id)
    now = Time.now
    quantities = Order.where(created_at: (now.beginning_of_day..now.end_of_day), user_id:).pluck(:quantity)
    quantities.present? && (count_ton(quantities) > 100) ? true : false
  end

  def count_ton(quantities)
    quantities.sum + quantity
  end

  def can_sell?
    wallet = Wallet.by_user_id_and_currency(user_id, 'ptt')
    if wallet.present? && wallet.available >= quantity
      true
    else
      errors.add(:error, 'insufficient PTT') # we can change message to send the quantity still available
      false
    end
  end

  def update_user_wallet
    Wallet.update_ptt(self)
  end
end
