class CSVCafeImporter
  class << self
    def import_file(file)
      reset_models
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
    end

    private

    def reset_models
      StreetCafe.destroy_all
      reset_pk_sequence
    end

    def reset_pk_sequence
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
    end
  end
end
