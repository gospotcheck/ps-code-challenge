class Restaurant < ApplicationRecord

  def categorize_ls1
    if number_of_chairs < 10
      self.update(category: 'ls1 small')
    elsif number_of_chairs >= 10 && number_of_chairs < 100
      self.update(category: 'ls1 medium')
    else
      self.update(category: 'ls1 large')
    end
  end

  def categorize_ls2(prefix)
    fifty_percentile = Restaurant.where("post_code like ?", "%#{prefix}%").percentile(:number_of_chairs, 0.50)
    if number_of_chairs < fifty_percentile
      self.update(category: 'ls2 small')
    else
      self.update(category: 'ls2 large')
    end
  end

  def to_csv
    [name, address, post_code, number_of_chairs, category, created_at, updated_at]
  end

  def self.categorize_restaurants
    restaurants = Restaurant.all
    restaurants.map do |restaurant|
      prefix = restaurant.post_code.split(" ")[0]
      if prefix == "LS1"
        restaurant.categorize_ls1
      elsif prefix == "LS2"
        restaurant.categorize_ls2(prefix)
      else
        restaurant.update(category: 'other')
      end
    end
  end

  def self.find_small_restaurants
    Restaurant.where("category like ?", "%small%")
  end

  def self.find_medium_large_restaurants
    Restaurant.where("category like ?", "%medium%").or(Restaurant.where("category like ?", "%large%"))
  end

  def self.update_medium_large_restaurant_names
    restaurants = Restaurant.find_medium_large_restaurants
    restaurants.each do |restaurant|
      cat_name = restaurant.category
      original_name = restaurant.name
      new_name = "#{cat_name} #{original_name}"
      restaurant.update(name: new_name)
    end
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
