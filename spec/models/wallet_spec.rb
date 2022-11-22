# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:user) { FactoryBot.create(:user) }

  subject do
    described_class.new(currency: 0,
                        available: 1,
                        user_id: user.id)
  end

  describe 'currency validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    it 'is missing' do
      subject.currency = nil
      expect(subject).to_not be_valid
    end

    it 'raise an error when wallet with same currency already exist' do
      # ensure_currency_wallet_not_exist
      FactoryBot.create(:wallet, :euro, user_id: user.id)
      expect do
        FactoryBot.create(:wallet, :euro,
                          user_id: user.id)
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: EUR wallet already exist.')
    end
  end
end
