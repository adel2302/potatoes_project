# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :wallets
  has_many :orders
  validates :login, presence: true, uniqueness: true, length: 6..15
  validates :password, length: 6..15, if: -> { new_record? || !password.nil? }
  after_save :create_wallets

  private

  def create_wallets
    Wallet.generate(id)
  end
end
