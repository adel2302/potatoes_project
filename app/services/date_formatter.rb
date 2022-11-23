# frozen_string_literal: true

module DateFormatter
  module_function

  def parse(day)
    day = (Time.now - 1.day).strftime('%d/%m/%Y') unless day.present?
    DateTime.parse(day)
  end
end
