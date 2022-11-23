# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @stock_price = FactoryBot.create(:stock_price)
    @user = FactoryBot.create(:user)
  end

  subject do
    described_class.new(side: 0,
                        quantity: 1,
                        stock_price_id: @stock_price.id,
                        user_id: @user.id)
  end

  describe 'side validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    it 'not be valid when side missing' do
      subject.side = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'quantity validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    it 'not be valid when quantity missing' do
      subject.quantity = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'stock_price_id validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    it 'not be valid when stock_price_id missing' do
      subject.stock_price_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'status validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    it 'not be valid when user_id missing' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
  end
end
