class CreatePostCodeDataView < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE VIEW post_code_data AS
        SELECT post_code,
        COUNT(name) as total_places,
        SUM(number_of_chairs) as total_chairs,
        ROUND(((SUM(number_of_chairs) * 100.0) / (SELECT SUM(number_of_chairs) FROM street_cafes)), 2) as chairs_pct,
        MAX(number_of_chairs) as max_chairs,
        (SELECT name 
          FROM street_cafes sc_2 
          WHERE sc_1.post_code = sc_2.post_code 
          ORDER BY number_of_chairs 
          DESC 
          LIMIT 1) as place_with_max_chairs
        FROM street_cafes sc_1
        GROUP BY post_code
        ORDER BY post_code;
    SQL
  end

  def down
    execute <<-SQL
      DROP VIEW IF EXISTS post_code_data
    SQL
  end
end
