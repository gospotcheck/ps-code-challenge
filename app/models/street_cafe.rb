class StreetCafe < ApplicationRecord
  class << self
    def get_ls2_cafes_chairs_list
      where("post_code LIKE 'LS2%'").order(:number_of_chairs).pluck(:number_of_chairs)
    end

    def cafes_by_category(*args)
      if args.length == 1
        where("category LIKE ?", args.first)
      elsif args.length == 2
        where("category LIKE ? OR category LIKE ?", args[0], args[1])  
      end
    end

    def find_duplicate_records
      select("MIN(id) as id").group(:name, :street_address).collect(&:id)
    end
  end
end
