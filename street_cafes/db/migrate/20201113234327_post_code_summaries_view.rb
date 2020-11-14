class PostCodeSummariesView < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE VIEW post_code_summaries AS
      SELECT
        post_code,
        (SELECT COUNT(name)) AS total_places,
        (SELECT SUM(number_of_chairs)) AS total_count,
        SUM(number_of_chairs) * 100.0 / SUM(SUM(number_of_chairs)) OVER () AS chairs_pct,
        (SELECT MAX(number_of_chairs)) AS place_with_max_chairs
      FROM restaurants
      GROUP BY post_code
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS post_code_summaries
    SQL
  end
end
