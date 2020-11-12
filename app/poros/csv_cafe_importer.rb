class CSVCafeImporter
  class << self
    def import_file(file)
      CSV.foreach(
        file, 
        headers: true,
        encoding:'iso-8859-1',
        header_converters: lambda { |header| header.downcase.tr(' ', '_') }) do |row|
          data = row.to_h
          data['name'] = data.delete('cafã©/restaurant_name')
          data['notes'] = data.delete(data['nil'])
          StreetCafe.create(data)
      end
      check_duplicates(file)
    end

    private

    def check_duplicates(file)
      if (CSV.read(file).length - 1) == StreetCafe.all.length
        return
      else
        delete_duplicates
      end
    end

    def delete_duplicates
      ids = StreetCafe.find_duplicate_records
      StreetCafe.delete(ids)
    end
  end
end
