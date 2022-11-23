# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockPrice, type: :model do
  subject { described_class.new(value: 121.0) }

  describe 'value validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    context 'not be valid' do
      it 'is missing' do
        subject.value = nil
        expect(subject).to_not be_valid
      end

      it 'is negative' do
        subject.value = -1.0
        expect(subject).to_not be_valid
      end
    end
  end
end
