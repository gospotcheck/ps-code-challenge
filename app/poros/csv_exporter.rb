class CSVExporter
  attr_reader :cafes

  def initialize(cafes)
    @cafes = cafes
  end

  def export_to_csv
    headers = [
      'Café/Restaurant Name',
      'Street Address',
      'Post Code', 
      'Number of Chairs',
      'Category',
      'Notes'
    ]
    CSV.generate(write_headers: true, headers: headers) do |csv|
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
  end

  def remove_cafes_from_db
    ids = cafes.pluck(:id)
    StreetCafe.delete(ids)
  end
end