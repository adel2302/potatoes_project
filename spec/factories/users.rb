# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    login { Faker::String.random(length: 6..15) }
    password { Faker::String.random(length: 6..15) }
  end
end
