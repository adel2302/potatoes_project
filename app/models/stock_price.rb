# frozen_string_literal: true

class StockPrice < ApplicationRecord
  has_many :orders
  validates :value, presence: true
  after_validation :add_format_error, if: proc { errors.empty? && value.negative? }
  scope :search_range, ->(day) { where('created_at BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day) }

  class << self
    def by_date(day)
      day = DateFormatter.parse(day)
      search_range(day).order(created_at: :asc)
    end

    def gain(day)
      day = DateFormatter.parse(day)
      values = search_range(day).order(created_at: :asc)
      ary =  values.present? ? minmax_ary(values) : [0.0, 0.0]
      Hash[gain: "#{Calculator.difference(ary)}€"]
    end

    private

    def parsed_date(day)
      day = (Time.now - 1.day).strftime('%d/%m/%Y') unless day.present?
      DateTime.parse(day)
    end

    def minmax_ary(values)
      first_value = values.first.value
      ary = [first_value, first_value]
      values.each do |v|
        if v.value < ary[0]
          ary[0] = v.value
        elsif v.value > ary[1]
          ary[1] = v.value
        end
      end
      ary
    end
  end

  def as_json
    Hash[time: created_at, value:]
  end

  private

  def add_format_error
    errors.add :base, :invalid, message: "Value can't be negative."
  end
end
