# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :wallets
  validates :login, presence: true, uniqueness: true, length: 6..15
  validates :password, length: 6..15, if: -> { new_record? || !password.nil? }
end
