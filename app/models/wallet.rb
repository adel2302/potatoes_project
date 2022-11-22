# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user
  validates :currency, presence: true
  after_validation :ensure_currency_wallet_not_exist, if: proc { errors.empty? }
  enum :currency, { eur: 0, ptt: 1 }, prefix: true

  private

  def ensure_currency_wallet_not_exist
    return unless user.wallets.method("currency_#{currency}".to_sym).call.exists?

    errors.add :base, :invalid, message: "#{currency.upcase} wallet already exist."
  end
end
