namespace :db do
  namespace :cafes do
    desc 'categorizes cafes based on size of chairs'
    task categorize_by_size: :environment do
      cafes = StreetCafe.all
      cafes.each do |cafe|
        CafeCategorizer.categorize(cafe)
      end
      puts "Categorized all cafes!"
    end

    desc 'Adds cafes categories to the beginning of Street Cafe names that are categorized as medium and large'
    task update_med_lg_cafe_names: :environment do
      CafeNameUpdater.update_cafe_names_by_category
      puts 'All medium and large cafe names have been updated'
    end
  end
end
