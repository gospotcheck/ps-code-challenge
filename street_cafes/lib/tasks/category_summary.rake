task :category_summary => :environment do
  result =  ActiveRecord::Base.connection.exec_query("SELECT * FROM category_summaries")
  result.each do |row|
    puts row
  end 
end
