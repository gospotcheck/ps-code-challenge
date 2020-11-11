namespace :db do
  namespace :categorize do
    desc 'categorizes cafes based on size of chairs'
    task cafes: :environment do
      cafes = StreetCafe.all
      cafes.each do |cafe|
        CafeCategorizer.categorize(cafe)
      end
      puts "Categorized all cafes!"
    end

    desc 'Adds cafes categories to the beginning of Street Cafe names that are categorized as medium and large'
    task update_names: :environment do
      cafes = StreetCafe.cafes_by_category('%medium', '%large') 
      cafes.update_all("name = CONCAT(category, ' ', name)")
      puts 'All medium and large cafe names have been updated'
    end
  end
end
