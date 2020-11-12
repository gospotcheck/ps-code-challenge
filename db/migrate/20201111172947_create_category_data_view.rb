class CreateCategoryDataView < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE VIEW cafe_data_by_category AS
        SELECT category,
        COUNT(name) as total_places,
        SUM(number_of_chairs) as total_chairs
        FROM street_cafes
        GROUP BY category
        ORDER BY category;
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS cafe_data_by_category
    SQL
  end
end
