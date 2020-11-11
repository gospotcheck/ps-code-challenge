class StreetCafe < ApplicationRecord
  class << self
    def get_ls2_chair_list
      where("post_code LIKE 'LS2%'").order(:number_of_chairs).pluck(:number_of_chairs)
    end

    def small_cafes
      where("category LIKE '%small'")
    end
  end
end
