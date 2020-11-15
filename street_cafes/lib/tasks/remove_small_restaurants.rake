namespace :export do
  task :remove_small_restaurants => :environment do
    @restaurants = Restaurant.find_small_restaurants
    csv_data = @restaurants.to_csv
    time_stamp = Time.now.strftime('%Y%m%dT%H%M')
    file_name = "./db/csv/exported_restaurants_#{time_stamp}.csv"

    File.write(file_name, csv_data)

    @restaurants.each do |restaurant|
      restaurant.destroy
    end
  end
end
