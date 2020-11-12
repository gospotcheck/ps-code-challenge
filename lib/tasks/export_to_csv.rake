namespace :db do
  namespace :export_and_delete do
    task small_cafes: :environment do
      cafes = StreetCafe.cafes_by_category('%small')
      csv_exporter = CSVExporter.new(cafes)
      csv_file = csv_exporter.export_to_csv
      puts 'Writing records to CSV'
      File.write("./lib/assets/Small Street Cafes #{Date.today}", csv_file)
      csv_exporter.remove_cafes_from_db
      puts 'Small cafe records were deleted from database'
    end
  end
end
