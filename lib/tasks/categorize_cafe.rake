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
  end
end