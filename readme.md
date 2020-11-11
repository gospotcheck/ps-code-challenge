![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202020-21.csv

So I downloaded the file and created a rake task to seed my database. I was able to confirm that this was created using the Rails console, and by interpolating the count of all the street_cafe records in the put statement at the end of the rake task. This required creating a StreetCafe model with all of the columns included in the csv file. I also had to do some string manipulation of the headers in the task to make them conform to the columns the model was expecting.

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

6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column
	
    *Please share any tests you wrote for #7*

8) Show your work and check your email for submission instructions.

9) Celebrate, you did great! 


