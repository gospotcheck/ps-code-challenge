class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :post_code
      t.integer :number_of_chairs
      t.string :category
    end
  end
end
