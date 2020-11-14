task :add_categories => :environment do
    Restaurant.categorize_restaurants
end
