# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(login: Faker::Lorem.characters(number: 6..15),
                        password: Faker::Lorem.characters(number: 6..15))
  end

  describe 'login validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    context 'not be valid' do
      it 'is missing' do
        subject.login = nil
        expect(subject).to_not be_valid
      end

      it 'length less than 6 caracteres' do
        subject.login = Faker::Lorem.characters(number: 5)
        expect(subject).to_not be_valid
      end

      it 'length more than 15 caracteres' do
        subject.login = Faker::Lorem.characters(number: 16)
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'password validation' do
    it 'be valid' do
      expect(subject).to be_valid
    end

    context 'not be valid' do
      it 'not be valid when is missing' do
        subject.password = nil
        expect(subject).to_not be_valid
      end

      it 'length less than 6 caracteres' do
        subject.password = Faker::Lorem.characters(number: 5)
        expect(subject).to_not be_valid
      end

      it 'length more than 15 caracteres' do
        subject.password = Faker::Lorem.characters(number: 16)
        expect(subject).to_not be_valid
      end
    end
  end
end
