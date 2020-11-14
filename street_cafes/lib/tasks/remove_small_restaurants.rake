task :remove_small_restaurants => :environment do
  Restaurant.to_csv
end
