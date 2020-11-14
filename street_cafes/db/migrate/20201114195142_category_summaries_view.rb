class CategorySummariesView < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE VIEW category_summaries AS
      SELECT
        category,
        (SELECT COUNT(name)) AS total_places,
        (SELECT SUM(number_of_chairs)) AS total_chairs
      FROM restaurants
      GROUP BY category
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS category_summaries
    SQL
  end
end
