require 'csv'

class SeedStarter
  class << self
    def destroy_models
      Restaurant.destroy_all
    end

    def create_restaurants
      restaurants = CSV.foreach("/Users/kristastadler/gospotcheck/ps-code-challenge/street_cafes/db/csv/Street Cafes 2020-21.csv", headers: true, header_converters: :symbol)
          restaurants.each do |row|
            Restaurant.create({
              name: row[:cafrestaurant_name],
              address: row[:street_address],
              post_code: row[:post_code],
              number_of_chairs: row[:number_of_chairs]
            })
      end
    end
  end
end
