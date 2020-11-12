class CafeNameUpdater
  class << self
    def update_cafe_names_by_category
      cafes = StreetCafe.cafes_by_category('%medium', '%large') 
      cafes.update_all("name = CONCAT(category, ' ', name)")
    end
  end
end
