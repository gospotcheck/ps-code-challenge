task :update_restaurant_names => :environment do
  Restaurant.update_medium_large_restaurant_names
  puts "Names of medium and large restaurants have been updated."
end
