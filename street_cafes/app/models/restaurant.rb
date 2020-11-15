class Restaurant < ApplicationRecord

  def categorize_ls1
    if number_of_chairs < 10
      return 'ls1 small'
    elsif number_of_chairs >= 10 && number_of_chairs < 100
      return 'ls1 medium'
    else
      return 'ls1 large'
    end
  end

  def categorize_ls2(prefix)
    fifty_percentile = Restaurant.where("post_code like ?", "%#{prefix}%").percentile(:number_of_chairs, 0.50)
    if number_of_chairs < fifty_percentile
      return 'ls2 small'
    else
      return 'ls2 large'
    end
  end

  def to_csv
    [name, address, post_code, number_of_chairs, category, created_at, updated_at]
  end

  def self.categorize_restaurants
    restaurants = Restaurant.all
    restaurants.map do |restaurant|
      prefix = restaurant.post_code.split(" ")[0]
      new_category = 'other'
      if prefix == "LS1"
        new_category = restaurant.categorize_ls1
      elsif prefix == "LS2"
        new_category = restaurant.categorize_ls2(prefix)
      end
      restaurant.update(category: new_category)
    end
  end

  def self.find_small_restaurants
    Restaurant.where(category: "ls1 small").or(Restaurant.where(category: "ls2 small"))
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv_file|
      csv_file << csv_header_row

      all.each do |restaurant|
        csv_file << restaurant.to_csv
      end
    end
  end

  def self.csv_header_row
    %w(name, address, post_code, number_of_chairs, category, created_at, updated_at)
  end
end
