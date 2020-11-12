![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

**Application info:**

`bundle install`

I used figaro for env variables so run:
`bundle exec figaro install`

this installs application.yml
`You'll need an env file with the variables IMPORT_PATH: "(path to the csv file)" and EXPORT_PATH: "(path where you want it to be written)"`

All of my rake tasks are:
Import cafes: `db:import:cafes`
Categorize cafes: `db:cafes:categorize_by_size`
Update names: `db:cafes:update_med_lg_cafe_names`
Export and Delete: `db:export_and_delete:small_cafes`

I used a sql structure so to load the view sql run:
`rake db:structure:load`


### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202020-21.csv

For this challenge all ruby objects I used as helpers are stored in the poros folder, all sql views are stored in the models folder along with the street cafe model (the raw sql is inside of the migrations folder), all tasks are in the lib/tasks folder, and all csv files are in the lib/assets folder. You can find the screenshots of the sql views from my terminal are in the DB folder. 

So I downloaded the file and created a rake task to seed my database. I was able to confirm that this was created using the Rails console, and by interpolating the count of all the street_cafe records in the put statement at the end of the rake task. This required creating a StreetCafe model with all of the columns included in the csv file. I also had to do some string manipulation of the headers in the task to make them conform to the columns the model was expecting.

I then refactored that functionality to a poro called CSVCafeImporter which is here:
https://github.com/zachholcomb/ps-code-challenge/blob/master/app/poros/csv_cafe_importer.rb

3) Add a varchar column to the table called `category`. 

I added a this via a Rails migration.

4) Create a view with the following columns[provide the view SQL]
    - post_code: The Post Code
    - total_places: The number of places in that Post Code
    - total_chairs: The total number of chairs in that Post Code
    - chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
    - place_with_max_chairs: The name of the place with the most chairs in that Post Code
    -max_chairs: The number of chairs at the place_with_max_chairs
	
    So I started with a model class method for the StreetCafe model that used a raw SQL statement to aggregate all of the data. I was testing the SQL statement against a test for that model method and got that working. I then did some research on SQL views and refactored the model method into a SQL view that I migrated into the database. This was nice because then I was able to interact with that view like it was a model and was able to move all of the tests I wrote into a post code sql view spec that used the same tests I originally wrote for the model method.
    
    Here's the migration I used to create the SQL view:
    ```ruby
    	execute <<-SQL
      CREATE VIEW post_code_data AS
        SELECT post_code,
        COUNT(name) as total_places,
        SUM(number_of_chairs) as total_chairs,
        ROUND(((SUM(number_of_chairs) * 100.0) / (SELECT SUM(number_of_chairs) FROM street_cafes)), 2) as chairs_pct,
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
    ```
    
    And here is the output from Rails db:
    ![Alt text](db/post_code_view_sql.png?raw=true "post_code_data SQL view")
    
    Spec for post code data: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/models/cafe_data_by_post_code_sql_view_spec.rb
    

5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
    - If the Post Code is of the LS1 prefix type:
        - `# of chairs less than 10: category = 'ls1 small'`
        - `# of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'`
        - `# of chairs greater than or equal to 100: category = 'ls1 large' `
    - If the Post Code is of the LS2 prefix type: 
        - `# of chairs below the 50th percentile for ls2: category = 'ls2 small'`
        - `# of chairs above the 50th percentile for ls2: category = 'ls2 large'`
    - For Post Code is something else:
        - `category = 'other'`

    *Please share any tests you wrote for #5*

    So I built a poro whose job was to check the parameters of the incoming cafes and see if they matched the rules above.
    That poro is here: https://github.com/zachholcomb/ps-code-challenge/blob/master/app/poros/cafe_categorizer.rb 
    I ended up going with class methods and memoizing the 50th_percentile variable to avoid having to initialize a new object for
    each cafe record. It also allowed me to make the 50th percentile calulation only once for the 73 objects.

    I then wrote a rake task that grabbed all of the records and called upon that poro to categorize each object.
    
    This is the task: https://github.com/zachholcomb/ps-code-challenge/blob/master/lib/tasks/categorize_cafes.rake

    I wrote specs for the poro and the tasks which you can find here:
    
    CafeCategorizer spec: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/poros/cafe_categorizer_spec.rb
    
    CafeCategorizer task spec: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/tasks/cafe_categorizer_task_spec.rb


6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

    Here is the view SQL I wrote to get this data, again I used a migration to create the view:
    ```Ruby
        execute <<-SQL
        CREATE VIEW cafe_category_data AS
            SELECT category,
            COUNT(name) as total_places,
            SUM(number_of_chairs) as total_chairs
            FROM street_cafes
            GROUP BY category
            ORDER BY category;
        SQL
    ```

    And this is a screenshot of the results:
    ![Alt text](db/cafe_category_data_sql_view.png?raw=true "category_data SQL view")

    I was then able to write tests to check the data against a smaller sample size for accuracy which are here:
    
    https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/models/cafe_category_data_sql_view_spec.rb

7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column
	
    *Please share any tests you wrote for #7*

    For the first task I built a poro, CSVExporter which takes in a group of cafes and its output formats their attributes as CSV. The task 
    then writes the csv to a file in the assets folder. What was nice about doing it this way was that I could test the output of CSVExporter before it was written to a file. I also used Environmental variables with the exporter task so that allows the task to be flexible and could be written wherever the file path passed in is. One thing to note is that I gitignored those env variables which are `IMPORT_PATH` and `EXPORT_PATH`. In my env file they are defined as "./lib/assets/Street Cafes 2020-21.csv" and "./lib/assets/Small Street Cafes" respectively. The export path is then concatenated with the date and file extension.
    
    EXPORTER PORO TESTS: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/poros/cafe_exporter_spec.rb
    
    EXPORT RAKE TASK TESTS: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/tasks/cafe_exporter_task_spec.rb
    
    And the output of the rake task is here: https://github.com/zachholcomb/ps-code-challenge/blob/master/lib/assets/Small%20Street%20Cafes%202020-11-11

    For the second task, I used a model method I wrote on StreetCafe to get all of the medium and large cafes that I wrote tests for. And then used the builtin activerecord update_all function to batch update the cafes by adding their category to the front of their name.

    Model Tests: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/models/street_cafe_spec.rb
    
    Test for Name Task: https://github.com/zachholcomb/ps-code-challenge/blob/master/spec/tasks/update_names_task_spec.rb

8) Show your work and check your email for submission instructions.

9) Celebrate, you did great! 

Thanks really enjoyed this challenge!

