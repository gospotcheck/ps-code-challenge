class CSVCafeExporter
  attr_reader :cafes, :file_path

  def initialize(cafes, file)
    @cafes = cafes
    @file_path = file
  end

  def export_to_csv
    csv_data = CSV.generate(write_headers: true, headers: headers) do |csv|
      cafes.each do |cafe|
        csv << [
          cafe.name, 
          cafe.street_address,
          cafe.post_code,
          cafe.number_of_chairs,
          cafe.category,
          cafe.notes
        ]
      end
    end
    write_csv_data_to_file(csv_data)
  end

  private

  def write_csv_data_to_file(csv_data)
    File.write(file_path, csv_data)
    remove_cafes_from_db
  end

  def remove_cafes_from_db
    ids = cafes.pluck(:id)
    StreetCafe.delete(ids)
  end

  def headers
    [
      'Café/Restaurant Name',
      'Street Address',
      'Post Code', 
      'Number of Chairs',
      'Category',
      'Notes'
    ]
  end
end