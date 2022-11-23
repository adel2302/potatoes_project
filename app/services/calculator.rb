# frozen_string_literal: true

module Calculator
  module_function

  def difference(min_max)
    (min_max[1] - min_max[0]) * 100
  end
end
