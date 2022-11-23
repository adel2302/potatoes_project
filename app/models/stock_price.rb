# frozen_string_literal: true

class StockPrice < ApplicationRecord
  validates :value, presence: true
  after_validation :add_format_error, if: proc { errors.empty? && value.negative? }
  scope :search_range, ->(day) { where('created_at BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day) }

  class << self
    def by_date(day)
      day = DateFormatter.parse(day)
      search_range(day).order(created_at: :desc)
    end

    private

    def parsed_date(day)
      day = (Time.now - 1.day).strftime('%d/%m/%Y') unless day.present?
      DateTime.parse(day)
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
