# Street Cafes Take Home Challenge

### Overview

This project is a backend Rails application that allows users to access information about street cafes through custom SQL views. Users can also manipulate data based on restaurant category.

### Local Setup

- Clone
- ```bundle```
- ```rails db:{create,migrate}```
- ```rails db:seed:from_csv```

### SQL Views

- ```post_code_summaries```
  - Includes the following columns:
    - post_code
    - total places: count of street cafes in the post code
    - total_count: total count of chairs available in that post code
    - chairs_pct: total chairs in post code as percentage of total chairs overall
    - max_chairs: maximum number of chairs at a single cafe in the post code
  - Verification of data:
    - To verify accuracy of the view data, I spot checked the calculations by using SQL queries:
      - First, I figured out total chairs among all cafes using the SQL query ```SELECT SUM(number_of_chairs) FROM restaurants;```
      - Then, I looked at cafe data for randomly selected post codes and made sure it matched the calculations in the post_code_summaries view. For example: ```SELECT * FROM restaurants WHERE restaurants.post_code ='LS1 8EQ';```

- ```category_summaries```
  - Includes the following columns:
    - category: the street cafe's category, as determined by the categorization script
    - total_places: the total number of cafes in that category
    - total_chairs: the total number of chairs available in that category
  - Verification of data:
    - To verify the accuracy of view data, I spot checked the calculations by looking at cafe data for randomly selected categories and made sure it matched the calculations in the category_summaries view. For example: ```SELECT * FROM restaurants WHERE restaurants.category ='ls2 large';```
  - Accessing results of the view:
    - Run ```rake category_summary``` to have data output to the terminal
