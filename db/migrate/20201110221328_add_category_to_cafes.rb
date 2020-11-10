class AddCategoryToCafes < ActiveRecord::Migration[5.2]
  def change
    add_column :street_cafes, :category, :varchar
  end
end
