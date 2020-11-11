namespace :db do
  namespace :import do
    desc 'imports cafes to db from Street Cafes csv'
    task cafes: :environment do
      StreetCafe.destroy_all

      CSV.foreach(
        './lib/assets/Street Cafes 2020-21.csv', 
        headers: true,
        encoding:'iso-8859-1',
        header_converters: lambda { |header| header.downcase.tr(' ', '_') }) do |row|
          data = row.to_h
          data['name'] = data.delete('cafã©/restaurant_name')
          data['notes'] = data.delete(data['nil'])
          StreetCafe.create(data)
      end
      puts "#{StreetCafe.all.length} cafes were imported to street_cafes table"
    end
  end
end
