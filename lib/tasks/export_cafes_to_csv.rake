namespace :db do
  namespace :export_and_delete do
    desc "Task to write small cafes from the database and then remove all small cafe records"
    task small_cafes: :environment do
      file_path = ENV['EXPORT_PATH'] + " #{Date.today}.csv"
      cafes = StreetCafe.cafes_by_category('%small')
      csv_exporter = CSVCafeExporter.new(cafes, file_path)
      csv_exporter.export_to_csv
      puts 'Small cafe records were written to CSV and deleted from DB'
    end
  end
end
