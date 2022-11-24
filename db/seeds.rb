# Today
value = 97
1.upto(5) do |i|
  Timecop.freeze(Time.now.beginning_of_day + i .hours) do
    StockPrice.create(value: value)
    value += i
  end
end

# Yesterday
1.upto(5) do |i|
  Timecop.freeze(Time.now.beginning_of_day - 1.day + i .hours) do
    StockPrice.create(value: value)
    value += i
  end
end

# Two days ago
1.upto(5) do |i|
  Timecop.freeze(Time.now.beginning_of_day - 2.days + i .hours) do
    StockPrice.create(value: value)
    value += i
  end
end
