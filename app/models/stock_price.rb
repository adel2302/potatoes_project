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

    # rubocop:disable Metrics/MethodLength
    def minmax_ary(values)
      first_value = values.first.value
      values_with_index = [[first_value, 0], [first_value, 0]]
      values.each do |element|
        element_index = values.find_index(element)
        smallest_value(values, element, values_with_index, element_index)
        biggest_value(element, values_with_index, element_index)
      end
      if values_with_index[0][1] < values_with_index[1][1]
        [values_with_index[0][0],
         values_with_index[1][0]]
      else
        [0.0, 0.0]
      end
    end
    # rubocop:enable Metrics/MethodLength

    def smallest_value(values, element, values_with_index, element_index)
      values[element_index..].each do |v|
        if element.value <= v.value && element.value <= values_with_index[0][0]
          values_with_index[0][0] = element.value
          values_with_index[0][1] = element_index
        end
      end
    end

    def biggest_value(element, values_with_index, element_index)
      return unless element.value >= values_with_index[1][0]

      values_with_index[1][0] = element.value
      values_with_index[1][1] = element_index
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
