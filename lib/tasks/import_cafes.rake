namespace :db do
  namespace :import do
    desc 'imports cafes to db from Street Cafes csv'
    task cafes: :environment do
      CSVCafeImporter.import_file(ENV['IMPORT_PATH'])
      puts "Cafes were checked for duplicates and imported to street_cafes table"
    end
  end
end
