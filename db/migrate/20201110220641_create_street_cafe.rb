class CreateStreetCafe < ActiveRecord::Migration[5.2]
  def change
    create_table :street_cafes do |t|
      t.string :name
      t.string :street_address
      t.string :post_code
      t.integer :number_of_chairs
      t.string :notes

      t.timestamps
    end
  end
end
