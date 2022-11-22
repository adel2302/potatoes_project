# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    available { 1.5 }
    trait :euro do
      currency { 0 }
    end
    trait :ptt do
      currency { 1 }
    end
  end
end
