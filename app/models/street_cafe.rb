class StreetCafe < ApplicationRecord
  class << self
    def get_ls2_chair_list
      where("post_code LIKE 'LS2%'").order(:number_of_chairs).pluck(:number_of_chairs)
    end

    def cafes_by_category(*args)
      if args.length == 1
        where("category LIKE ?", args.first)
      elsif args.length == 2
        where("category LIKE ? OR category LIKE ?", args[0], args[1])  
      end
    end
  end
end
