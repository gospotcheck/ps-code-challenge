class StreetCafe < ApplicationRecord
  def self.get_ls2_chair_list
    where("post_code LIKE 'LS2%'").order(:number_of_chairs).pluck(:number_of_chairs)
  end
end
