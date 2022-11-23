# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    login { Faker::Lorem.characters(number: 6..15) }
    password { Faker::Lorem.characters(number: 6..15) }
  end
end
