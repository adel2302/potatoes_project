# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user
  validates :currency, presence: true
  after_validation :ensure_currency_wallet_not_exist, if: proc { errors.empty? && new_record? }
  enum :currency, { euro: 0, ptt: 1 }, prefix: true

  def self.by_user_id_and_currency(user_id, cur)
    where(user_id:).method("currency_#{cur}".to_sym).call.first
  end

  def self.update_ptt(order)
    wallet = Wallet.where(user_id: order.user_id).currency_ptt.first
    available_sum = if order.side == 'buy'
                      wallet.available + order.quantity
                    else
                      wallet.available - order.quantity
                    end
    wallet.update(available: available_sum)
  end

  def self.generate(user_id)
    Wallet.currencies.each_key do |currency|
      Wallet.create(currency: currency.to_sym, user_id:)
    end
  end

  private

  def ensure_currency_wallet_not_exist
    return unless user.wallets.method("currency_#{currency}".to_sym).call.exists?

    errors.add :base, "#{currency.upcase} wallet already exist."
  end
end
