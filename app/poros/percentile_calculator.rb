class PercentileCalculator
  def self.calculate_percentile(percentile, total_values, list)
    index = ((percentile / 100) * (total_values + 1)) - 1
    if index % 1 == 0
      value_at_index = list[index]
    else
      index_above = index.round
      index_below = index.floor
      value = (list[index_above] + list[index_below]).to_f / 2
    end
  end
end