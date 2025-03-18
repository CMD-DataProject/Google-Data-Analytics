# <u>**Google-Capstone Bike Share**<u>

## :black_nib: **Introduction**

The **Cyclistic Bike Share Case Study** is a *Capstone project* for the **Google Data Analytics Professional Certificate** on Coursera. The key of this project is following the data analysis process, studied from the course: <ins>ask, prepare, process, analyze, share and act</ins> to analyze the dataset. 

## :spiral_notepad: **Background**

In this case study, you're a junior data analyst working for Cyclistic, a bike-share company in Chicago. Your team, led by the marketing director, aims to increase the number of annual memberships. To achieve this, you need to understand the differences in usage patterns between casual riders and annual members. The goal is to design a marketing strategy to convert casual riders into annual members, backed by compelling data insights and visualizations. 

***Cyclistic***, known for its inclusive bike options, has successfully attracted a diverse user base, but the focus now is on driving future growth through annual memberships. Analyzing historical bike trip data will be key to identifying trends and making data-driven recommendations.

## :hammer_and_wrench: **Approach**

### 1. Ask

*Design marketing* strategies to **convert casual riders to members** by understanding how these riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics.<br>

> Question for guiding the marketing program: **How do annual members and casual riders use Cyclistic bikes differently?**

### 2. Prepare

#### :heavy_minus_sign: Links:

**Data Source:** Q1 2019 and Q1 2020 from  [divvy-tripdata](https://divvy-tripdata.s3.amazonaws.com/index.html) <br>

#### :heavy_minus_sign: Tools:

* Data cleaning & processing - Big Query, Excel and PowerQuery.
* Data transformation: PowerQuery.
* Data visualization: PowerBI.

#### :heavy_minus_sign: Assumptions.

* *Station Dataset*

  - I used the latitude and the longitude to approximate map the start and end dock to a neighbourhood in Chicago.
  - These neighbourhoods are taken from **Choose Chicago**, which is the official destination marketing organization for Chicago, listed in their website https://www.choosechicago.com/neighborhoods/. <br>
  - It also has been allocated each neighbourhood to an area category based on online research: *tourist*, *residential*, *business*. As a result, the different routes can also be a combination of two categories.
  - Based on the **Route** the following variables have been included to explain further the data:

    - *Duration category* variable: allocated the ride to 5, 10, 15, 30, 60, 90, 120 minutes.
    - *Time of the day* variable: divides the day into the following time blocks:

      - *Morning* from 6:00 am to 12 pm.
      - *Afternoon* from 12:00 pm to 6:00 pm.
      - *Evening* from 6:00 pm to 12 am.
      - *Afternoon* from 12:00 am to 6:00 am.
    
    **Note**:
    If the ride transitions from one block to another, It would be categorised as so. For example, if the ride starts at 23:00 and finishes at 1:00 am, would be categorised as *Evening-Night*. In the same way:
    
    - *Day category* variable: allocates the **route** in *weekend* and *weekday* and also, in a similar way, would flag the transition between types.
    - *Month and Day Category* variables: which month the **route** happened and also, will state the transition between months.
  
* *Cleaned Dataset*

  - *Table* 1 in the Appendix, includes the station dock's ID and names mapped to a neighbourhood (approximately based on the provided latitude and longitude) and also it has been categorized as Tourist, Business or Residential. This has been added to explain further behaviours and trends.
  
  - *The Q1 2020* dataset and the *Q1 2019* have different labels for categorizing the user. As 2020 is the most recent one, the labelling has been remapped, hence Member (2020) = Subscriber (2019) and Casual (2020) = Customer (2019). Only the 2020 labels have been used in the headers hence *Member_casual* is the header with the unique values of *Member* and *Casual*.

### 3. Process

The analysis has been saved in the following paths:
1) [Data Combining](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/1_Data%20Combining.SQL)
2) [Data Exploration](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/2_Data%20Exploration.SQL)
3) [Data Cleaning](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/3_Data%20Cleaning.SQL)
4) [Data Analysis](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/4_Data%20Analysis.PowerBI)

#### :heavy_minus_sign: Data Combination.

The 2 tables  from ** Q1 2019 to Q1 2020 ** were appended into a single table with a total of **791,958** rows.

#### :heavy_minus_sign: Data Exploring.

* *Station Dataset*, consists of the following *12 variables*:

| **Number** | **Variable**       | **Type** |
|------------|--------------------|----------|
| 1          | start_station_id   | String   |
| 2          | start_station_name | String   |
| 3          | start_area         | String   |
| 4          | start_category     | String   |
| 5          | start_latitude     | Float    |
| 6          | start_longitude    | Float    |
| 7          | end_station_id     | String   |
| 8          | end_station_name   | String   |
| 9          | end_area           | String   |
| 10         | end_category       | String   |
| 11         | end_latitude       | Float    |
| 12         | end_longitude      | Float    |

* *Cleaned Dataset* consists of the following *13 variables*:

I noticed that there was not a standardised process set up for both years. The main issue was related to the fact that the headers for these datasets were different. Also, the data type for the *ride_id* / *trip_id* was different as one uses a combination of *text and numbers* and the other had a *numeric* format, so the *trip_id* column was transformed to store *string* data.

| **Number** | **Variable**       | **Type** |
|------------|--------------------|----------|
| 1          | start_station_id   | String   |
| 2          | start_station_name | String   |
| 3          | end_station_id     | String   |
| 4          | end_station_name   | String   |
| 5          | member_casual      | String   |
| 6          | year               | String   |
| 7          | duration           | Float    |
| 8          | duration_category  | String   |
| 9          | day_category       | String   |
| 10         | hour_category      | String   |
| 11         | month_category     | String   |
| 12         | ride_id            | String   |
| 13         | Count              | Float    |

#### :heavy_minus_sign: Data Cleaning. 

- **BigQuery** to run queries to:
  
  - Removing the trips with **null or blank values** and **duplicates** if any.
  - Removing the rides with a duration  **less than 5 minutes** and also any **rides with a duration above 2 hours** as the battery life of Divvy e-bikes can vary depending on usage, but typically, the battery lasts for about 1.5 to 2 hours of continuous riding.
  - Adding in the following columns with code:
    
    - *Hour category*
    - *Day category*
    - *Month category*
    - *Duration category*
      
  - The headers from **2019** file was transformed to keep it in line with the **2020** version.
  - The column *usertype* in **2019** has been transformed to keep it in line with the **2020** data.
  - The column *trip_id* in **2019** had a *numeric* datatype which has been transformed to a *string* to keep it in line with **2020**.
  - The *Duration*.  

- **PowerQuery** used to trim data and also to group all columns in both tables to guarantee the uniqueness of each row, and also, to benefit the analysis in later stages.

#### :heavy_minus_sign: Data Combination.

- **PowerBI**
  
  - Reviewed the data types.
  - Adding in the following columns with code:
    
    - *Hour category* 
    - *Day category* 
    - *Month category*
    - *Duration category* - This has been ca
    - *Q1 Year*

  - The column "ride id" was deleted as caused errors. This does not an issue for the analysis.  
  - Total rows after the cleaning stage: **571,697** rows.
  
### 4. Analyze

The analysis question is: 
  > **How do annual members and casual riders use Cyclistic bikes differently?** <be>

To help answer this question, profiled the data to answer the following questions:
    
#### :heavy_minus_sign: *What is the change between **Q1 2019** and **Q1 2019**?* 

The figure below shows the **Percentage of Change from Q1 2019 to Q1 2020** in the Cyclistic users.

<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/1-metrics.png">
</div>
<br>

-* **Total Level** shows an increase of 13.71% with respect of the same period in 2019. <br>
-* **Cyclistic Members** represented an increase of 6.25%.<br>
-* **Cyclistic Casual** represented an increase of 87.87%.<br> 
<br>
#### :heavy_minus_sign: *Time Insights*
<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/2-time-insights.png">
</div>
<br>

- **Year Trends** <br>

  * **Q1 2019** 
    - *Member:* Consistently account for the majority of bike hires throughout Q1, showing steady and reliable usage patterns.
    - *Casual:* Contribute much less overall, with sporadic growth in March. <br>
       
  * **Q1 2020**
    
    - *Member:* Despite leading again, their overall numbers declined compared to 2019, hinting at external impacts.
    - *Casual:* Show slight growth in March but remain lower than members across all months. <br>
    
- **Monthly Trends** <br>

  * **January** <br>
  
    - *Member:* Consistently dominate bike hires across both years, reflecting steady usage.
    - *Casual:* Casual Users: Lower activity compared to members, with minimal changes over the years. <br>
  * **February** <br>
  
    - *Member:* Maintain higher numbers, although there is a slight decline in 2020 compared to 2019.
    - *Casual:* Show little variation but remain significantly fewer than members. <br>
    
  * **March** <br>
  
    - *Member:* See a noticeable spike in March of both years, indicating seasonal or event-related influence.
    - *Casual:* Exhibit a modest increase compared to previous months, potentially due to improving weather or holidays. <br>
    
#### :heavy_minus_sign: *When do the users ride most: Weekdays or Weekends?*
The figure below shows a breakdown of bikes hired categorized by type of users and weekends and weekdays.
<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/3-Time_days.png">
</div>

- **Weekday** <br>

  * *Member: (69.19%).* A significant majority of hires come from members during weekdays. This suggests that members predominantly use bikes for commuting or regular weekday routines.<br>      
  * *Casual: (6.19%).* Casual hires during weekdays are quite minimal, indicating that they are less likely to use bikes for weekday activities.<br>
    
- **Weekdend** <br>

  * *Member: (19.12%).* Members also show a noticeable share of weekend usage, highlighting consistent engagement even outside of workdays. This could reflect leisure or recreational purposes. <br>
  * *Casual: (5.49%.)* Casual users show a slightly higher percentage on weekends compared to weekdays, likely driven by recreational or occasional users taking advantage of free time. <br>
     
#### :heavy_minus_sign: *What time of the day do users hire bikes the most?*
<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/4-Time-ridesbyTime%20of%20the%20day.png">
</div>

- **Morning** <br>

  * *Member:* A significant number of hires occur, reflecting consistent commuting or structured routines.
  * *Casual:* Minimal activity; casual users rarely ride during this time, likely due to the lack of leisure-related demand.<br>
  
- **Afternoon** <br>

  * *Member:* Peak activity, possibly tied to errands, mid-day travels, or flexible commuting patterns.
  * *Casual:* Also peak activity; this period appeals to recreational and leisure users, aligning with casual users' primary motivations.<br>
  
- **Evening** <br>

  * *Member:* Moderate activity levels, likely tied to the end-of-day commute or leisure trips.
  * *Casual:* Slight activity, indicating some evening recreation but far less compared to members.<br>
  
- **Night** <br>
              
   * *Member:* Low activity; members may occasionally use bikes during late hours but at reduced rates.
   * *Casual:* Very minimal activity, reflecting limited demand for late-night leisure rides.<br>
</div>

#### :heavy_minus_sign: *Which routes are the most popular by neighbourhoods?*
The following pie chart shows the top routes by neighbourhood.
<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/5-route_areas.png">
</div>

The top routes take place in the following neighbourhoods:

</div>

- **Lincoln Park - Lincoln Park (35.01%):** Dominates as the most popular route, potentially reflecting recreational or short local trips within this neighbourhood. 
- **Logan Square - Logan Square (21.9%):** Significant in popularity, suggesting high local activity within this neighbourhood, possibly among residents.    
- **Loop - Loop (19.69%):** As a key central area, this route likely represents business commutes or short trips in the city centre.
- **Loop - West Loop (11.94%):** This is a moderately popular route, indicating a strong connection between these two bustling neighbourhoods.
- **West Loop - Loop (11.46%):** Mirroring the previous route, the near-equal percentage demonstrates mutual traffic flow between these neighbourhoods.

#### :heavy_minus_sign: *Which ones are the top Routes?* 
The following table shows the most popular routes.
<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/6-route_list.png">
</div>

- **Q1 2019 Analysis:**

  * *Member:* Member users consistently show lower numbers compared to casual users across all routes.
    - The **"Lake Shore Dr & Monroe St - Lake Shore Dr & Monroe St"** route is again the most used by members, though significantly outnumbered by casual users.
    - Member usage appears steady but less prominent, possibly reflecting structured commuting rather than leisure trips.
  
  * *Casual:* Casual users dominate the usage of most routes this year.
    - The **"Lake Shore Dr & Monroe St - Lake Shore Dr & Monroe St"** route has the highest casual user count, suggesting it is a prime choice for recreational or scenic travel.
    - Other popular routes like **"Streeter Dr & Grand Ave - Streeter Dr & Grand Ave"** also indicate high casual rider activity, likely due to accessibility and proximity to popular destinations.

- **Q1 2020 Analysis:**

  * *Member:* Member usage remains stable or even increases slightly across certain routes in Q1 2020, contrasting with the decline seen among casual users.
    - The **"Lake Shore Dr & Monroe St - Lake Shore Dr & Monroe St"** route continues to lead in member activity, suggesting a mix of commuting and regular travel habits.
    - Routes like **"Michigan Ave & Oak St - Michigan Ave & Oak St"** exhibit steady member usage, possibly for routine or work-related trips.
  
  * *Casual:* Casual users dominate the usage of most routes this year.
    - The **"Lake Shore Dr & Monroe St - Lake Shore Dr & Monroe St"** route has the highest casual user count, suggesting it is a prime choice for recreational or scenic travel.
    - Other popular routes like **"Streeter Dr & Grand Ave - Streeter Dr & Grand Ave"** also indicate high casual rider activity, likely due to accessibility and proximity to popular destinations.

**"Lake Shore Dr & Monroe St - Lake Shore Dr & Monroe St"** is consistently the most popular route across both years and user groups, highlighting its significance.

#### :heavy_minus_sign: *Route User Overview* 
The following bar chart outlines a number of users by trip purposes categorized by *Residential*, *Business*, *Tourist*.

<div align="center">
<br>
<img src="https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Images/7-route_user.png">
</div>

- **Residential - Residential:**
    
   - ***Casual Users:***
        
      - *Q1 2019:* Casual users had notable participation, reflecting a preference for occasional local trips.
      - *Q1 2020:*  Numbers drop significantly, suggesting a decline in leisure or spontaneous commutes.
        
   - ***Member Users:***
        
      - *Q1 2019:* The highest participation for members, highlighting their reliance on daily commutes.
      - *Q1 2020:* Member users maintain or slightly increase their numbers, showing steady use despite external changes.

- **Business - Business:**
  
  - ***Casual Users:***

      - *Q1 2019:* Moderate use, likely for sporadic business trips.
      - *Q1 2020:* Activity sharply declines, possibly indicating a shift to remote work or reduced non-essential travel.

  - ***Member Users:***

      - *Q1 2019:* Stable usage, indicative of regular work-related travel.
      - *Q1 2020:* Little change, suggesting this category remains consistent for commuting.

- **Residential - Business:**

  - ***Casual Users:***

      - *Q1 2019:* Participation is decent, reflecting occasional travel to work-related areas.
      - *Q1 2020:* A noticeable decline aligns with reduced casual travel patterns.

  - ***Member Users:***

      - *Q1 2019:* Strong participation as part of routine work commutes.
      - *Q1 2020:* Numbers remain consistent, further emphasizing regularity in commuting.

- **Tourist-Related Categories:**

  - ***Casual Users:***

    - *Q1 2019:* These categories see moderate participation, driven by leisure trips and tourism.
    - *Q1 2020:* Numbers plummet sharply, possibly due to limited travel opportunities or restrictions during the period due Covid-19 Pandemic.

  - ***Member Users:***

    - *Q1 2019:* Low activity, as members tend to focus on regular travel rather than leisure.
    - *Q1 2020:* Activity remains minimal, reflecting a consistent lack of emphasis on tourism.

There is a further statistical analysis performed with R which is located here:

    >![Stats.R](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/Stats.R)

Worth highlighting the **Chi-squared analysis** done to understand if there is a statistically significant relationship between the variables *Day_Category* and *Member_Casual*. 
  
  - *Ho -Null Hypothesis-* there is no relationship between customer type and the type of the day.
  - *H1* there is such relationship
    
The value of the statistic is 13,907, which indicates the observed data differs from what would be expected under the null hypothesis -if these variables are independent-. There is only one degree of freedom, as there are two categories for each variable -member and casual- and -weekend and weekday-. The P-value is very small, can be cosindered 0, so we reject the null hypothesis at any significance level of 0.01 or 0.05.  So this means that Members and Casual riders have different patterns of trip frequency on weekdays and weekend.
    
### 5. Share
Dashboard can be downloaded from the following link:[project_bikes_google](https://github.com/CMD-DataProject/Google-Data-Analytics/blob/main/project_bikes_google.pbix)
    
### 6. Act

**Cyclistic Membership Marketing Strategies**
Based on the analysis, we propose the following strategies to convert casual riders into Cyclistic members:

- **Membership Personalization:**
  Provide flexible membership plans, this variety allows users to choose a plan that best suits their needs. Short-term membership plans at affordable rates cater to riders who might not require an annual commitment.
  - *Yearly*
  - *Monthly*
  - *Weekly*
  - *Daily*

- **Group Membership Discounts.**
  Offer discounted memberships for students or team up with colectives like unions to offer discounts.

- **Membership Loyalty Points System**
  Introduce a loyalty program where members earn points for each ride. Points can be redeemed for:
  - Discounts in local business or attactions.
  - Membership discounts
  - Other exclusive rewards

- **Seasonal Campaigns.**
  Launch seasonal promotions including:
  - Limited-time discounts
  - Special weekday offers
  - Extended ride durations for members.
    
- **Social Media Engagement: Utilize social media platforms to:**  
  - Find well known social media embassadors within the travel and cycling sector.
  - Share success stories and testimonials from Cyclistic members.
  - Post visually appealing content showcasing the joy of cycling.
  - Highlight membership benefits through user-generated content.

## **7-Conclusion**

One main point for these dataset is the impact of the **Covid-19 Pandemic**.

- * *Casual Users**. There is a significant decline aligned with the travel restrictions, non-essential travel and lockdowns. These reduced travel and leisure activities.
- * *Members**. Overall, remained consistent with only minor reductions compared to the casual users. This could be possible because these subscriptors use this service for their regular commute to work and this considered *essential* and they can not work from home. This can be proved as the key time blocks are mornings and evenings -considered commuting hours- showed limited changes in their travel behaviour.
  
  
## **8-Appendix**

### Table 1

| ID  | Location                                    | Category    | Neigborhood        |
|-----|---------------------------------------------|-------------|--------------------|
| 2   | Buckingham Fountain                         | Business    | Loop               |
| 3   | Shedd Aquarium                              | Tourist     | Museum Campus      |
| 4   | Burnham Harbor                              | Residential | Near South Side    |
| 5   | State St & Harrison St                      | Residential | South Loop         |
| 6   | Dusable Harbor                              | Business    | Near North Side    |
| 7   | Field Blvd & South Water St                 | Business    | Loop               |
| 9   | Leavitt St & Archer Ave                     | Residential | Brighton Park      |
| 11  | Jeffery Blvd & 71st St                      | Residential | South Shore        |
| 12  | South Shore Dr & 71st St                    | Residential | South Shore        |
| 13  | Wilton Ave & Diversey Pkwy                  | Residential | Lincoln Park       |
| 14  | Morgan St & 18th St                         | Business    | Pilsen             |
| 15  | Racine Ave & 18th St                        | Business    | Pilsen             |
| 16  | Paulina Ave & North Ave                     | Residential | Lakeview           |
| 17  | Honore St & Division St                     | Residential | Logan Square       |
| 18  | Wacker Dr & Washington St                   | Business    | Loop               |
| 19  | Throop (Loomis) St & Taylor St              | Residential | Lawndale           |
| 20  | Sheffield Ave & Kingsbury St                | Residential | Lincoln Park       |
| 21  | Aberdeen St & Jackson Blvd                  | Business    | West Loop          |
| 22  | May St & Taylor St                          | Business    | Pilsen             |
| 23  | Orleans St & Elm St                         | Business    | Near North Side    |
| 24  | Fairbanks Ct & Grand Ave                    | Business    | Near North Side    |
| 25  | Michigan Ave & Pearson St                   | Business    | Gold Coast         |
| 26  | McClurg Ct & Illinois St                    | Business    | Streeterville      |
| 27  | Larrabee St & North Ave                     | Residential | Lincoln Park       |
| 28  | Larrabee St & Menomonee St                  | Residential | Lincoln Park       |
| 29  | Noble St & Milwaukee Ave                    | Business    | Wicker Park        |
| 30  | Ashland Ave & Augusta Blvd                  | Residential | Logan Square       |
| 31  | Franklin St & Chicago Ave                   | Business    | River North        |
| 32  | Racine Ave & Congress Pkwy                  | Residential | Near West Side     |
| 33  | State St & Van Buren St                     | Business    | Loop               |
| 34  | Cannon Dr & Fullerton Ave                   | Residential | Lincoln Park       |
| 35  | Streeter Dr & Grand Ave                     | Business    | Streeterville      |
| 36  | Franklin St & Jackson Blvd                  | Business    | West Loop          |
| 37  | Dearborn St & Adams St                      | Business    | Loop               |
| 38  | Clark St & Lake St                          | Residential | Lincoln Park       |
| 39  | Wabash Ave & Adams St                       | Business    | Loop               |
| 40  | LaSalle St & Adams St                       | Business    | Loop               |
| 41  | Federal St & Polk St                        | Residential | Near West Side     |
| 42  | Wabash Ave & Cermak Rd                      | Residential | Bronzeville        |
| 43  | Michigan Ave & Washington St                | Business    | Loop               |
| 44  | State St & Randolph St                      | Business    | Loop               |
| 45  | Michigan Ave & Ida B Wells Dr               | Business    | Loop               |
| 46  | Wells St & Walton St                        | Business    | River North        |
| 47  | State St & Kinzie St                        | Business    | River North        |
| 48  | Larrabee St & Kingsbury St                  | Residential | Lincoln Park       |
| 49  | Dearborn St & Monroe St                     | Business    | Loop               |
| 50  | Clark St & Ida B Wells Dr                   | Business    | Loop               |
| 51  | Clark St & Randolph St                      | Business    | Near North Side    |
| 52  | Michigan Ave & Lake St                      | Residential | South Loop         |
| 53  | Wells St & Huron St                         | Business    | River North        |
| 54  | Ogden Ave & Chicago Ave                     | Residential | Near West Side     |
| 55  | Halsted St & Roosevelt Rd                   | Residential | Near South Side    |
| 56  | Desplaines St & Kinzie St                   | Residential | River West         |
| 57  | Clinton St & Roosevelt Rd                   | Residential | Near West Side     |
| 58  | Marshfield Ave & Cortland St                | Residential | Lincoln Park       |
| 59  | Wabash Ave & Roosevelt Rd                   | Residential | South Loop         |
| 60  | Dayton St & North Ave                       | Residential | Logan Square       |
| 61  | Wood St & Milwaukee Ave                     | Business    | West Town          |
| 62  | McCormick Place                             | Residential | Near South Side    |
| 66  | Clinton St & Lake St                        | Business    | West Loop          |
| 67  | Sheffield Ave & Fullerton Ave               | Residential | Lincoln Park       |
| 68  | Clinton St & Tilden St                      | Residential | Near West Side     |
| 69  | Damen Ave & Pierce Ave                      | Residential | Logan Square       |
| 71  | Morgan St & Lake St                         | Business    | West Loop          |
| 72  | Wabash Ave & 16th St                        | Residential | South Loop         |
| 73  | Jefferson St & Monroe St                    | Business    | West Loop          |
| 74  | Kingsbury St & Erie St                      | Residential | River West         |
| 75  | Canal St & Jackson Blvd                     | Business    | West Loop          |
| 76  | Lake Shore Dr & Monroe St                   | Business    | Loop               |
| 77  | Clinton St & Madison St                     | Business    | West Loop          |
| 80  | Aberdeen St & Monroe St                     | Business    | West Loop          |
| 81  | Daley Center Plaza                          | Business    | Loop               |
| 84  | Milwaukee Ave & Grand Ave                   | Residential | Logan Square       |
| 85  | Michigan Ave & Oak St                       | Residential | South Loop         |
| 86  | Eckhart Park                                | Business    | West Town          |
| 87  | Racine Ave & Fullerton Ave                  | Residential | Logan Square       |
| 88  | Racine Ave & Randolph St                    | Business    | West Loop          |
| 89  | Financial Pl & Ida B Wells Dr               | Business    | Loop               |
| 90  | Millennium Park                             | Business    | Loop               |
| 91  | Clinton St & Washington Blvd                | Residential | Near West Side     |
| 92  | Carpenter St & Huron St                     | Business    | West Loop          |
| 93  | Sheffield Ave & Willow St                   | Residential | Lincoln Park       |
| 94  | Clark St & Armitage Ave                     | Residential | Lincoln Park       |
| 95  | Stony Island Ave & 64th St                  | Residential | South Shore        |
| 96  | Desplaines St & Randolph St                 | Residential | Near West Side     |
| 97  | Field Museum                                | Tourist     | Museum Campus      |
| 98  | LaSalle St & Washington St                  | Business    | Loop               |
| 99  | Lake Shore Dr & Ohio St                     | Business    | Streeterville      |
| 100 | Orleans St & Merchandise Mart Plaza         | Residential | River West         |
| 101 | 63rd St Beach                               | Residential | South Shore        |
| 102 | Stony Island Ave & 67th St                  | Residential | South Shore        |
| 103 | Clinton St & Polk St                        | Business    | West Loop          |
| 106 | State St & Pearson St                       | Business    | Gold Coast         |
| 107 | Desplaines St & Jackson Blvd                | Business    | West Loop          |
| 108 | Halsted St & Polk St                        | Residential | Near West Side     |
| 109 | 900 W Harrison St                           | Residential | Near West Side     |
| 110 | Dearborn St & Erie St                       | Business    | Loop               |
| 111 | Sedgwick St & Huron St                      | Business    | Old Town           |
| 112 | Green St & Randolph St                      | Business    | West Loop          |
| 113 | Bissell St & Armitage Ave                   | Residential | Lincoln Park       |
| 114 | Sheffield Ave & Waveland Ave                | Residential | Lakeview           |
| 115 | Sheffield Ave & Wellington Ave              | Residential | Lincoln Park       |
| 116 | Western Ave & Winnebago Ave                 | Residential | Logan Square       |
| 117 | Wilton Ave & Belmont Ave                    | Residential | Lincoln Park       |
| 118 | Sedgwick St & North Ave                     | Residential | Lincoln Park       |
| 119 | Ashland Ave & Lake St                       | Residential | South Loop         |
| 120 | Wentworth Ave & Cermak Rd (Temp)            | Residential | Bronzeville        |
| 121 | Blackstone Ave & Hyde Park Blvd             | Residential | Hyde Park          |
| 122 | Ogden Ave & Congress Pkwy                   | Residential | Near West Side     |
| 123 | California Ave & Milwaukee Ave              | Residential | Logan Square       |
| 124 | Damen Ave & Cullerton St                    | Business    | Pilsen             |
| 125 | Rush St & Hubbard St                        | Business    | Near North Side    |
| 126 | Clark St & North Ave                        | Residential | Lincoln Park       |
| 127 | Lincoln Ave & Fullerton Ave                 | Residential | Lincoln Park       |
| 128 | Damen Ave & Chicago Ave                     | Residential | Logan Square       |
| 129 | Blue Island Ave & 18th St                   | Business    | Pilsen             |
| 130 | Damen Ave & Division St                     | Residential | Logan Square       |
| 131 | Lincoln Ave & Belmont Ave                   | Residential | Lincoln Park       |
| 132 | Wentworth Ave & 24th St (Temp)              | Residential | Bronzeville        |
| 133 | Kingsbury St & Kinzie St                    | Residential | River West         |
| 134 | Peoria St & Jackson Blvd                    | Business    | West Loop          |
| 135 | Halsted St & 21st St                        | Business    | Pilsen             |
| 136 | Racine Ave & 13th St                        | Residential | Near West Side     |
| 137 | Morgan Ave & 14th Pl                        | Business    | Pilsen             |
| 138 | Clybourn Ave & Division St                  | Residential | Lincoln Park       |
| 140 | Dearborn Pkwy & Delaware Pl                 | Business    | Gold Coast         |
| 141 | Clark St & Lincoln Ave                      | Residential | Lincoln Park       |
| 142 | McClurg Ct & Erie St                        | Business    | Streeterville      |
| 143 | Sedgwick St & Webster Ave                   | Residential | Lincoln Park       |
| 144 | Larrabee St & Webster Ave                   | Residential | Lincoln Park       |
| 145 | Mies van der Rohe Way & Chestnut St         | Business    | Streeterville      |
| 146 | Loomis St & Jackson Blvd                    | Residential | Near West Side     |
| 147 | Indiana Ave & 26th St                       | Business    | Bridgeport         |
| 148 | State St & 33rd St                          | Residential | South Loop         |
| 149 | Calumet Ave & 33rd St                       | Residential | Bronzeville        |
| 150 | Fort Dearborn Dr & 31st St                  | Residential | Bronzeville        |
| 152 | Lincoln Ave & Diversey Pkwy                 | Residential | Lincoln Park       |
| 153 | Southport Ave & Wellington Ave              | Residential | Lakeview           |
| 154 | Southport Ave & Belmont Ave                 | Residential | Lakeview           |
| 156 | Clark St & Wellington Ave                   | Residential | Lakeview           |
| 157 | Lake Shore Dr & Wellington Ave              | Residential | Lakeview           |
| 158 | Milwaukee Ave & Wabansia Ave                | Residential | Logan Square       |
| 159 | Claremont Ave & Hirsch St                   | Residential | Logan Square       |
| 160 | Campbell Ave & North Ave                    | Residential | Logan Square       |
| 161 | Rush St & Superior St                       | Business    | River North        |
| 162 | Damen Ave & Wellington Ave                  | Residential | Logan Square       |
| 163 | Damen Ave & Clybourn Ave                    | Residential | Lincoln Park       |
| 164 | Franklin St & Lake St                       | Business    | West Loop          |
| 165 | Clark St & Grace St                         | Residential | Lincoln Park       |
| 166 | Ashland Ave & Wrightwood Ave                | Residential | Lincoln Park       |
| 167 | Damen Ave & Coulter St                      | Residential | Logan Square       |
| 168 | Michigan Ave & 14th St                      | Residential | South Loop         |
| 169 | Canal St & Harrison St                      | Business    | West Loop          |
| 170 | Clinton St & 18th St                        | Residential | Near West Side     |
| 171 | May St & Cullerton St                       | Business    | Little Village     |
| 172 | Rush St & Cedar St                          | Business    | Gold Coast         |
| 173 | Mies van der Rohe Way & Chicago Ave         | Business    | Near North Side    |
| 174 | Canal St & Madison St                       | Business    | Loop               |
| 175 | Wells St & Polk St                          | Residential | Near West Side     |
| 176 | Clark St & Elm St                           | Business    | Old Town           |
| 177 | Theater on the Lake                         | Residential | Lincoln Park       |
| 178 | State St & 19th St                          | Residential | Near South Side    |
| 179 | MLK Jr Dr & Pershing Rd                     | Residential | South Loop         |
| 180 | Ritchie Ct & Banks St                       | Business    | Near North Side    |
| 181 | LaSalle St & Illinois St                    | Business    | Loop               |
| 182 | Wells St & Elm St                           | Business    | Old Town           |
| 183 | Damen Ave & Thomas St (Augusta Blvd)        | Residential | Logan Square       |
| 184 | State St & 35th St                          | Residential | Bronzeville        |
| 185 | Stave St & Armitage Ave                     | Residential | Logan Square       |
| 186 | Ogden Ave & Race Ave                        | Residential | Near West Side     |
| 188 | Greenview Ave & Fullerton Ave               | Residential | Lincoln Park       |
| 190 | Southport Ave & Wrightwood Ave              | Residential | Lakeview           |
| 191 | Canal St & Monroe St                        | Business    | West Loop          |
| 192 | Canal St & Adams St                         | Business    | Loop               |
| 193 | State St & 29th St                          | Residential | Near South Side    |
| 194 | Wabash Ave & Wacker Pl                      | Business    | Loop               |
| 195 | Columbus Dr & Randolph St                   | Business    | Loop               |
| 196 | Cityfront Plaza Dr & Pioneer Ct             | Business    | Streeterville      |
| 197 | Michigan Ave & Madison St                   | Business    | West Loop          |
| 198 | Green St & Madison St                       | Residential | Near West Side     |
| 199 | Wabash Ave & Grand Ave                      | Business    | Loop               |
| 200 | MLK Jr Dr & 47th St                         | Residential | Washington Heights |
| 201 | Indiana Ave & 40th St                       | Residential | Bronzeville        |
| 202 | Halsted St & 18th St                        | Business    | Pilsen             |
| 203 | Western Ave & 21st St                       | Business    | Pilsen             |
| 204 | Prairie Ave & Garfield Blvd                 | Residential | Washington Park    |
| 205 | Paulina St & 18th St                        | Business    | Pilsen             |
| 206 | Halsted St & Archer Ave                     | Residential | Brighton Park      |
| 207 | Emerald Ave & 28th St                       | Residential | Bronzeville        |
| 208 | Laflin St & Cullerton St                    | Business    | Little Village     |
| 209 | Normal Ave & Archer Ave                     | Residential | Brighton Park      |
| 210 | Ashland Ave & Division St                   | Residential | Logan Square       |
| 211 | St. Clair St & Erie St                      | Business    | Gold Coast         |
| 212 | Wells St & Hubbard St                       | Business    | River North        |
| 213 | Leavitt St & North Ave                      | Residential | Logan Square       |
| 214 | Damen Ave & Grand Ave                       | Residential | Logan Square       |
| 215 | Damen Ave & Madison St                      | Business    | West Loop          |
| 216 | California Ave & Division St                | Residential | Logan Square       |
| 217 | Elizabeth (May) St & Fulton St              | Residential | Near West Side     |
| 218 | Wells St & 19th St                          | Residential | Near South Side    |
| 219 | Damen Ave & Cortland St                     | Residential | Logan Square       |
| 220 | Clark St & Drummond Pl                      | Business    | Old Town           |
| 222 | Milwaukee Ave & Rockwell St                 | Residential | Logan Square       |
| 223 | Clifton Ave & Armitage Ave                  | Residential | Lincoln Park       |
| 224 | Halsted St & Willow St                      | Residential | Lincoln Park       |
| 225 | Halsted St & Dickens Ave                    | Residential | Lincoln Park       |
| 226 | Racine Ave & Belmont Ave                    | Residential | Logan Square       |
| 227 | Southport Ave & Waveland Ave                | Residential | Lakeview           |
| 228 | Damen Ave & Melrose Ave                     | Residential | Lakeview           |
| 229 | Southport Ave & Roscoe St                   | Residential | Lakeview           |
| 230 | Lincoln Ave & Roscoe St                     | Residential | Roscoe Village     |
| 231 | Sheridan Rd & Montrose Ave                  | Residential | Edgewater          |
| 232 | Pine Grove Ave & Waveland Ave               | Residential | Lakeview           |
| 233 | Sangamon St & Washington Blvd               | Residential | Near West Side     |
| 234 | Clark St & Montrose Ave                     | Residential | Uptown             |
| 236 | Sedgwick St & Schiller St                   | Business    | Old Town           |
| 237 | MLK Jr Dr & 29th St                         | Residential | Bronzeville        |
| 238 | Wolcott (Ravenswood) Ave & Montrose Ave     | Residential | Ravenswood         |
| 239 | Western Ave & Leland Ave                    | Residential | Logan Square       |
| 240 | Sheridan Rd & Irving Park Rd                | Residential | Uptown             |
| 241 | Morgan St & Polk St                         | Residential | Near West Side     |
| 242 | Damen Ave & Leland Ave                      | Residential | Logan Square       |
| 243 | Lincoln Ave & Sunnyside Ave                 | Residential | Lincoln Square     |
| 244 | Ravenswood Ave & Irving Park Rd             | Residential | Ravenswood         |
| 245 | Clarendon Ave & Junior Ter                  | Residential | Uptown             |
| 246 | Ashland Ave & Belle Plaine Ave              | Residential | Lincoln Square     |
| 247 | Shore Dr & 55th St                          | Residential | Hyde Park          |
| 248 | Woodlawn Ave & 55th St                      | Residential | Woodlawn           |
| 249 | Montrose Harbor                             | Residential | Uptown             |
| 250 | Ashland Ave & Wellington Ave                | Residential | Logan Square       |
| 251 | Clarendon Ave & Leland Ave                  | Residential | Uptown             |
| 252 | Greenwood Ave & 47th St                     | Residential | Hyde Park          |
| 253 | Winthrop Ave & Lawrence Ave                 | Residential | Edgewater          |
| 254 | Pine Grove Ave & Irving Park Rd             | Residential | Lakeview           |
| 255 | Indiana Ave & Roosevelt Rd                  | Residential | South Loop         |
| 256 | Broadway & Sheridan Rd                      | Residential | Edgewater          |
| 257 | Lincoln Ave & Waveland Ave                  | Residential | Lincoln Park       |
| 258 | Logan Blvd & Elston Ave                     | Residential | Logan Square       |
| 259 | California Ave & Francis Pl (Temp)          | Residential | Logan Square       |
| 260 | Kedzie Ave & Milwaukee Ave                  | Residential | Logan Square       |
| 261 | Hermitage Ave & Polk St                     | Residential | Near West Side     |
| 262 | Halsted St & 37th St                        | Residential | Englewood          |
| 263 | Rhodes Ave & 32nd St                        | Residential | Bronzeville        |
| 264 | Stetson Ave & South Water St                | Business    | Loop               |
| 265 | Cottage Grove Ave & Oakwood Blvd            | Residential | Bronzeville        |
| 267 | Lake Park Ave & 47th St                     | Residential | South Shore        |
| 268 | Lake Shore Dr & North Blvd                  | Residential | Lincoln Park       |
| 270 | Stony Island Ave & 75th St                  | Residential | South Shore        |
| 271 | Cottage Grove Ave & 43rd St                 | Residential | Englewood          |
| 272 | Indiana Ave & 31st St                       | Business    | Bridgeport         |
| 273 | Michigan Ave & 18th St                      | Residential | Near South Side    |
| 274 | Racine Ave & 15th St                        | Residential | Near West Side     |
| 275 | Ashland Ave & 13th St                       | Business    | Pilsen             |
| 276 | California Ave & North Ave                  | Residential | Logan Square       |
| 277 | Ashland Ave & Grand Ave                     | Business    | Wicker Park        |
| 278 | Wallace St & 35th St                        | Business    | Bridgeport         |
| 279 | Halsted St & 35th St                        | Residential | Englewood          |
| 280 | Morgan St & 31st St                         | Residential | Bronzeville        |
| 281 | Western Ave & 24th St                       | Business    | Pilsen             |
| 282 | Halsted St & Maxwell St                     | Business    | Pilsen             |
| 283 | LaSalle St & Jackson Blvd                   | Business    | Loop               |
| 284 | Michigan Ave & Jackson Blvd                 | Residential | South Loop         |
| 285 | Wood St & Hubbard St                        | Business    | West Loop          |
| 286 | Franklin St & Adams St (Temp)               | Business    | West Loop          |
| 287 | Franklin St & Monroe St                     | Business    | West Loop          |
| 288 | Larrabee St & Armitage Ave                  | Residential | Lincoln Park       |
| 289 | Wells St & Concord Ln                       | Business    | River North        |
| 290 | Kedzie Ave & Palmer Ct                      | Residential | Irving Park        |
| 291 | Wells St & Evergreen Ave                    | Residential | Lincoln Park       |
| 292 | Southport Ave & Clark St                    | Residential | Lakeview           |
| 293 | Broadway & Wilson Ave                       | Residential | Lakeview           |
| 294 | Broadway & Berwyn Ave                       | Residential | Lakeview           |
| 295 | Broadway & Argyle St                        | Residential | Uptown             |
| 296 | Broadway & Belmont Ave                      | Residential | Lakeview           |
| 297 | Paulina St & Montrose Ave                   | Residential | Lincoln Square     |
| 298 | Lincoln Ave & Belle Plaine Ave              | Residential | Lincoln Square     |
| 299 | Halsted St & Roscoe St                      | Residential | Lakeview           |
| 300 | Broadway & Barry Ave                        | Residential | Lakeview           |
| 301 | Clark St & Schiller St                      | Business    | Old Town           |
| 302 | Sheffield Ave & Wrightwood Ave              | Residential | Lincoln Park       |
| 303 | Broadway & Cornelia Ave                     | Residential | Lakeview           |
| 304 | Broadway & Waveland Ave                     | Residential | Lakeview           |
| 305 | Western Ave & Division St                   | Residential | Logan Square       |
| 306 | Sheridan Rd & Buena Ave                     | Residential | Edgewater          |
| 307 | Southport Ave & Clybourn Ave                | Residential | Lincoln Park       |
| 308 | Seeley Ave & Roscoe St                      | Residential | Roscoe Village     |
| 309 | Leavitt St & Armitage Ave                   | Residential | Lincoln Park       |
| 310 | Damen Ave & Charleston St                   | Residential | Logan Square       |
| 311 | Leavitt St & Lawrence Ave                   | Residential | Logan Square       |
| 312 | Clarendon Ave & Gordon Ter                  | Residential | Lakeview           |
| 313 | Lakeview Ave & Fullerton Pkwy               | Residential | Lincoln Park       |
| 314 | Ravenswood Ave & Berteau Ave                | Residential | Ravenswood         |
| 315 | Elston Ave & Wabansia Ave                   | Residential | Logan Square       |
| 316 | Damen Ave & Sunnyside Ave                   | Residential | Lincoln Square     |
| 317 | Wood St & Taylor St                         | Residential | Near West Side     |
| 318 | Southport Ave & Irving Park Rd              | Residential | Lakeview           |
| 319 | Greenview Ave & Diversey Pkwy               | Residential | Lincoln Park       |
| 320 | Loomis St & Lexington St                    | Business    | Pilsen             |
| 321 | Wabash Ave & 9th St                         | Residential | South Loop         |
| 322 | Kimbark Ave & 53rd St                       | Residential | Hyde Park          |
| 323 | Sheridan Rd & Lawrence Ave                  | Residential | Rogers Park        |
| 324 | Stockton Dr & Wrightwood Ave                | Residential | Lincoln Park       |
| 325 | Clark St & Winnemac Ave                     | Residential | Lincoln Square     |
| 326 | Clark St & Leland Ave                       | Residential | Lincoln Park       |
| 327 | Sheffield Ave & Webster Ave                 | Residential | Lincoln Park       |
| 328 | Ellis Ave & 58th St                         | Residential | Hyde Park          |
| 329 | Lake Shore Dr & Diversey Pkwy               | Residential | Lincoln Park       |
| 330 | Lincoln Ave & Addison St                    | Residential | Lincoln Park       |
| 331 | Halsted St & Clybourn Ave                   | Residential | Lincoln Park       |
| 332 | Burling St (Halsted) & Diversey Pkwy (Temp) | Residential | Lincoln Park       |
| 333 | Ashland Ave & Blackhawk St                  | Residential | Lincoln Park       |
| 334 | Lake Shore Dr & Belmont Ave                 | Residential | Lakeview           |
| 335 | Calumet Ave & 35th St                       | Residential | Bronzeville        |
| 336 | Cottage Grove Ave & 47th St                 | Residential | Englewood          |
| 337 | Clark St & Chicago Ave                      | Business    | Near North Side    |
| 338 | Calumet Ave & 18th St                       | Residential | Bronzeville        |
| 339 | Emerald Ave & 31st St                       | Residential | Bronzeville        |
| 340 | Clark St & Wrightwood Ave                   | Residential | Lincoln Park       |
| 341 | Adler Planetarium                           | Tourist     | Museum Campus      |
| 342 | Wolcott Ave & Polk St                       | Residential | Lincoln Park       |
| 343 | Racine Ave & Wrightwood Ave                 | Residential | Lincoln Park       |
| 344 | Ravenswood Ave & Lawrence Ave               | Residential | Ravenswood         |
| 345 | Lake Park Ave & 56th St                     | Residential | Hyde Park          |
| 346 | Ada St & Washington Blvd                    | Business    | West Loop          |
| 347 | Ashland Ave & Grace St                      | Residential | Logan Square       |
| 348 | California Ave & 21st St                    | Business    | Little Village     |
| 349 | Halsted St & Wrightwood Ave                 | Residential | Lincoln Park       |
| 350 | Ashland Ave & Chicago Ave                   | Residential | Logan Square       |
| 351 | Cottage Grove Ave & 51st St                 | Residential | Englewood          |
| 352 | Jeffery Blvd & 67th St                      | Residential | South Shore        |
| 353 | Clark St & Touhy Ave                        | Residential | Rogers Park        |
| 354 | Sheridan Rd & Greenleaf Ave                 | Residential | Rogers Park        |
| 355 | South Shore Dr & 67th St                    | Residential | South Shore        |
| 356 | Stony Island Ave & 71st St                  | Residential | South Shore        |
| 359 | Larrabee St & Division St                   | Residential | Lincoln Park       |
| 360 | DIVVY Map Frame B/C Station                 | Business    | Loop               |
| 360 | DIVVY Map Frame B/C Station                 | Business    | Loop               |
| 361 | DIVVY CASSETTE REPAIR MOBILE STATION        | Business    | Loop               |
| 361 | DIVVY CASSETTE REPAIR MOBILE STATION        | Business    | Loop               |
| 364 | Larrabee St & Oak St                        | Residential | Lincoln Park       |
| 365 | Halsted St & North Branch St                | Residential | Lincoln Square     |
| 366 | Loomis St & Archer Ave                      | Business    | Pilsen             |
| 367 | Racine Ave & 35th St                        | Residential | Bronzeville        |
| 368 | Ashland Ave & Archer Ave                    | Residential | Brighton Park      |
| 369 | Wood St & 35th St                           | Business    | Bridgeport         |
| 370 | Calumet Ave & 21st St                       | Residential | Bronzeville        |
| 373 | Kedzie Ave & Chicago Ave                    | Business    | Little Village     |
| 374 | Western Ave & Walton St                     | Business    | West Town          |
| 375 | Sacramento Blvd & Franklin Blvd             | Residential | Garfield Park      |
| 376 | Artesian Ave & Hubbard St                   | Residential | Logan Square       |
| 377 | Kedzie Ave & Lake St                        | Residential | Logan Square       |
| 378 | California Ave & Lake St                    | Residential | Humboldt Park      |
| 381 | Western Ave & Monroe St                     | Residential | Near West Side     |
| 382 | Western Ave & Congress Pkwy                 | Residential | Near West Side     |
| 383 | Paulina St & Flournoy St                    | Residential | Near West Side     |
| 384 | Halsted St & 51st St                        | Residential | Fuller Park        |
| 384 | Halsted St & 51st St                        | Residential | Fuller Park        |
| 385 | Princeton Ave & Garfield Blvd               | Residential | Washington Heights |
| 386 | Halsted St & 56th St                        | Residential | Washington Heights |
| 388 | Halsted St & 63rd St                        | Residential | Englewood          |
| 390 | Wentworth Ave & 63rd St                     | Residential | Englewood          |
| 391 | Halsted St & 69th St                        | Residential | Englewood          |
| 392 | Perry Ave & 69th St                         | Residential | Englewood          |
| 392 | Perry Ave & 69th St                         | Residential | Englewood          |
| 393 | Calumet Ave & 71st St                       | Residential | Washington Heights |
| 394 | Clark St & 9th St (AMLI)                    | Business    | Near North Side    |
| 395 | Jeffery Blvd & 76th St                      | Residential | South Shore        |
| 395 | Jeffery Blvd & 76th St                      | Residential | South Shore        |
| 396 | Yates Blvd & 75th St                        | Residential | South Shore        |
| 398 | Rainbow Beach                               | Residential | South Shore        |
| 399 | South Shore Dr & 74th St                    | Residential | South Shore        |
| 400 | Cottage Grove Ave & 71st St                 | Residential | South Shore        |
| 401 | Shields Ave & 28th Pl                       | Business    | Bridgeport         |
| 402 | Shields Ave & 31st St                       | Business    | Bridgeport         |
| 403 | Wentworth Ave & 33rd St                     | Business    | Bridgeport         |
| 405 | Wentworth Ave & 35th St                     | Residential | Bronzeville        |
| 406 | Lake Park Ave & 35th St                     | Residential | Hyde Park          |
| 407 | State St & Pershing Rd                      | Residential | Bronzeville        |
| 408 | Union Ave & Root St                         | Business    | Pilsen             |
| 409 | Shields Ave & 43rd St                       | Residential | Washington Park    |
| 409 | Shields Ave & 43rd St                       | Residential | Washington Park    |
| 410 | Prairie Ave & 43rd St                       | Residential | Bronzeville        |
| 411 | Halsted St & 47th Pl                        | Residential | Canaryville        |
| 411 | Halsted St & 47th Pl                        | Residential | Canaryville        |
| 412 | Princeton Ave & 47th St                     | Residential | South Shore        |
| 413 | Woodlawn Ave & Lake Park Ave                | Residential | Woodlawn           |
| 414 | Canal St & Taylor St                        | Business    | Loop               |
| 415 | Calumet Ave & 51st St                       | Residential | Washington Heights |
| 416 | Dorchester Ave & 49th St                    | Residential | South Shore        |
| 417 | Cornell Ave & Hyde Park Blvd                | Residential | Hyde Park          |
| 418 | Ellis Ave & 53rd St                         | Residential | Hyde Park          |
| 419 | Lake Park Ave & 53rd St                     | Residential | Hyde Park          |
| 420 | Ellis Ave & 55th St                         | Residential | Hyde Park          |
| 421 | MLK Jr Dr & 56th St                         | Residential | Washington Heights |
| 422 | DuSable Museum                              | Residential | Bronzeville        |
| 423 | University Ave & 57th St                    | Residential | Hyde Park          |
| 424 | Museum of Science and Industry              | Residential | Hyde Park          |
| 425 | Harper Ave & 59th St                        | Residential | Hyde Park          |
| 426 | Ellis Ave & 60th St                         | Residential | Hyde Park          |
| 427 | Cottage Grove Ave & 63rd St                 | Residential | Woodlawn           |
| 428 | Dorchester Ave & 63rd St                    | Residential | South Shore        |
| 429 | Cottage Grove Ave & 67th St                 | Residential | South Shore        |
| 430 | MLK Jr Dr & 63rd St                         | Residential | Englewood          |
| 431 | Eberhart Ave & 61st St                      | Residential | Woodlawn           |
| 431 | Eberhart Ave & 61st St                      | Residential | Woodlawn           |
| 432 | Clark St & Lunt Ave                         | Residential | Rogers Park        |
| 433 | Kedzie Ave & Harrison St                    | Residential | West Garfield Park |
| 434 | Ogden Ave & Roosevelt Rd                    | Residential | Near West Side     |
| 435 | Kedzie Ave & Roosevelt Rd                   | Residential | Lawndale           |
| 436 | Fairfield Ave & Roosevelt Rd                | Residential | Near West Side     |
| 437 | Washtenaw Ave & Ogden Ave                   | Residential | Logan Square       |
| 438 | Central Park Ave & Ogden Ave                | Residential | Austin             |
| 439 | Kedzie Ave & 21st St                        | Business    | Little Village     |
| 440 | Central Park Ave & 24th St                  | Residential | Austin             |
| 441 | Kedzie Ave & 24th St                        | Business    | Little Village     |
| 442 | California Ave & 23rd Pl                    | Business    | Little Village     |
| 443 | Millard Ave & 26th St                       | Business    | Little Village     |
| 444 | Albany Ave & 26th St                        | Business    | Little Village     |
| 445 | California Ave & 26th St                    | Business    | Little Village     |
| 446 | Western Ave & 28th St                       | Residential | McKinley Park      |
| 447 | Glenwood Ave & Morse Ave                    | Residential | Rogers Park        |
| 448 | Warren Park East                            | Residential | Rogers Park        |
| 449 | Clark St & Columbia Ave                     | Residential | Lincoln Park       |
| 450 | Warren Park West                            | Residential | Lincolnwood        |
| 451 | Sheridan Rd & Loyola Ave                    | Residential | Rogers Park        |
| 452 | Western Ave & Granville Ave                 | Residential | Edgewater          |
| 453 | Clark St & Schreiber Ave                    | Residential | Andersonville      |
| 454 | Broadway & Granville Ave                    | Residential | Edgewater          |
| 455 | Maplewood Ave & Peterson Ave                | Residential | Lincoln Square     |
| 456 | 2112 W Peterson Ave                         | Residential | Sauganash          |
| 457 | Clark St & Elmdale Ave                      | Residential | Edgewater          |
| 458 | Broadway & Thorndale Ave                    | Residential | Edgewater          |
| 459 | Lakefront Trail & Bryn Mawr Ave             | Residential | Edgewater          |
| 460 | Clark St & Bryn Mawr Ave                    | Residential | Edgewater          |
| 461 | Broadway & Ridge Ave                        | Residential | Lakeview           |
| 462 | Winchester (Ravenswood) Ave & Balmoral Ave  | Residential | Ravenswood         |
| 463 | Clark St & Berwyn Ave                       | Residential | Andersonville      |
| 464 | Damen Ave & Foster Ave                      | Residential | Jefferson Park     |
| 465 | Marine Dr & Ainslie St                      | Residential | Edgewater          |
| 466 | Ridge Blvd & Touhy Ave                      | Residential | West Ridge         |
| 467 | Western Ave & Lunt Ave                      | Residential | West Rogers Park   |
| 468 | Budlong Woods Library                       | Residential | Lincoln Square     |
| 469 | St. Louis Ave & Balmoral Ave                | Residential | Sauganash          |
| 470 | Kedzie Ave & Foster Ave                     | Residential | Albany Park        |
| 471 | Francisco Ave & Foster Ave                  | Residential | Jefferson Park     |
| 472 | Lincoln Ave & Winona St                     | Residential | Lincoln Square     |
| 474 | Christiana Ave & Lawrence Ave               | Residential | Logan Square       |
| 475 | Washtenaw Ave & Lawrence Ave                | Residential | Logan Square       |
| 476 | Kedzie Ave & Leland Ave                     | Residential | Logan Square       |
| 477 | Manor Ave & Leland Ave                      | Residential | Logan Square       |
| 478 | Rockwell St & Eastwood Ave                  | Residential | Lincoln Square     |
| 479 | Drake Ave & Montrose Ave                    | Residential | Lincoln Square     |
| 480 | Albany Ave & Montrose Ave                   | Residential | Irving Park        |
| 481 | California Ave & Montrose Ave               | Residential | Jefferson Park     |
| 482 | Campbell Ave & Montrose Ave                 | Residential | Ravenswood         |
| 483 | Avondale Ave & Irving Park Rd               | Residential | Avondale           |
| 484 | Monticello Ave & Irving Park Rd             | Residential | Logan Square       |
| 485 | Sawyer Ave & Irving Park Rd                 | Residential | Irving Park        |
| 486 | Oakley Ave & Irving Park Rd                 | Residential | Logan Square       |
| 487 | California Ave & Byron St                   | Residential | Logan Square       |
| 488 | Pulaski Rd & Eddy St (Temp)                 | Residential | Archer Heights     |
| 489 | Drake Ave & Addison St                      | Residential | Jefferson Park     |
| 490 | Troy St & Elston Ave                        | Residential | Irving Park        |
| 491 | Talman Ave & Addison St                     | Residential | Logan Square       |
| 492 | Leavitt St & Addison St                     | Residential | Logan Square       |
| 493 | Western Ave & Roscoe St                     | Residential | Roscoe Village     |
| 494 | Kedzie Ave & Bryn Mawr Ave                  | Residential | Lincoln Square     |
| 495 | Keystone Ave & Montrose Ave                 | Residential | Jefferson Park     |
| 496 | Avers Ave & Belmont Ave                     | Residential | Logan Square       |
| 497 | Kimball Ave & Belmont Ave                   | Residential | Logan Square       |
| 498 | California Ave & Fletcher St                | Residential | Logan Square       |
| 499 | Kosciuszko Park                             | Residential | Irving Park        |
| 500 | Central Park Ave & Elbridge Ave             | Residential | Logan Square       |
| 501 | Richmond St & Diversey Ave                  | Residential | Logan Square       |
| 502 | California Ave & Altgeld St                 | Residential | Logan Square       |
| 503 | Drake Ave & Fullerton Ave                   | Residential | Logan Square       |
| 504 | Campbell Ave & Fullerton Ave                | Residential | Logan Square       |
| 505 | Winchester Ave & Elston Ave                 | Residential | Lincoln Square     |
| 506 | Spaulding Ave & Armitage Ave                | Residential | Logan Square       |
| 507 | Humboldt Blvd & Armitage Ave                | Residential | Logan Square       |
| 508 | Central Park Ave & North Ave                | Residential | Humboldt Park      |
| 509 | Troy St & North Ave                         | Residential | Logan Square       |
| 510 | Spaulding Ave & Division St                 | Residential | Logan Square       |
| 511 | Albany Ave & Bloomingdale Ave               | Residential | Logan Square       |
| 514 | Ridge Blvd & Howard St                      | Residential | West Ridge         |
| 515 | Paulina St & Howard St                      | Residential | Rogers Park        |
| 517 | Clark St & Jarvis Ave                       | Residential | Rogers Park        |
| 518 | Conservatory Dr & Lake St                   | Residential | Garfield Park      |
| 519 | Wolcott Ave & Fargo Ave                     | Residential | Logan Square       |
| 520 | Greenview Ave & Jarvis Ave                  | Residential | Rogers Park        |
| 522 | Bosworth Ave & Howard St                    | Residential | Ravenswood         |
| 523 | Eastlake Ter & Rogers Ave                   | Residential | Edgewater          |
| 524 | Austin Blvd & Chicago Ave                   | Residential | Austin             |
| 525 | Glenwood Ave & Touhy Ave                    | Residential | Rogers Park        |
| 526 | Oakley Ave & Touhy Ave                      | Residential | Jefferson Park     |
| 527 | Western Ave & Howard St                     | Residential | Edgewater          |
| 528 | Pulaski Rd & Lake St                        | Residential | Garfield Ridge     |
| 529 | Cicero Ave & Lake St                        | Residential | Austin             |
| 529 | Cicero Ave & Lake St                        | Residential | Austin             |
| 530 | Laramie Ave & Kinzie St                     | Residential | Austin             |
| 530 | Laramie Ave & Kinzie St                     | Residential | Austin             |
| 531 | Central Ave & Lake St                       | Residential | Austin             |
| 532 | Austin Blvd & Lake St                       | Residential | Austin             |
| 533 | Central Park Blvd & 5th Ave                 | Residential | Austin             |
| 534 | Karlov Ave & Madison St                     | Residential | Austin             |
| 534 | Karlov Ave & Madison St                     | Residential | Austin             |
| 535 | Pulaski Rd & Congress Pkwy                  | Residential | Near West Side     |
| 536 | Kostner Ave & Lake St                       | Residential | Austin             |
| 537 | Kenton Ave & Madison St                     | Residential | Austin             |
| 537 | Kenton Ave & Madison St                     | Residential | Austin             |
| 538 | Cicero Ave & Flournoy St                    | Residential | Lawndale           |
| 539 | Cicero Ave & Quincy St                      | Business    | Little Village     |
| 540 | Laramie Ave & Madison St                    | Residential | Galewood           |
| 541 | Central Ave & Harrison St                   | Residential | Austin             |
| 542 | Central Ave & Madison St                    | Residential | Garfield Park      |
| 543 | Laramie Ave & Gladys Ave                    | Residential | Galewood           |
| 544 | Austin Blvd & Madison St                    | Residential | Austin             |
| 545 | Kostner Ave & Adams St                      | Residential | Austin             |
| 545 | Kostner Ave & Adams St                      | Residential | Austin             |
| 546 | Damen Ave & Pershing Rd                     | Residential | McKinley Park      |
| 547 | Ashland Ave & Pershing Rd                   | Residential | Bronzeville        |
| 548 | Morgan St & Pershing Rd                     | Residential | McKinley Park      |
| 549 | Marshfield Ave & 44th St                    | Residential | Englewood          |
| 550 | Central Ave & Chicago Ave                   | Residential | Austin             |
| 551 | Hoyne Ave & 47th St                         | Residential | Englewood          |
| 552 | Ashland Ave & McDowell Ave                  | Residential | Logan Square       |
| 553 | Elizabeth St & 47th St                      | Residential | West Englewood     |
| 554 | Damen Ave & 51st St                         | Residential | Englewood          |
| 555 | Ashland Ave & 50th St                       | Residential | Englewood          |
| 556 | Throop St & 52nd St                         | Residential | Washington Park    |
| 557 | Seeley Ave & Garfield Blvd                  | Residential | Englewood          |
| 557 | Seeley Ave & Garfield Blvd                  | Residential | Englewood          |
| 558 | Ashland Ave & Garfield Blvd                 | Residential | Englewood          |
| 559 | Racine Ave & Garfield Blvd                  | Residential | Englewood          |
| 560 | Marshfield Ave & 59th St                    | Residential | Englewood          |
| 560 | Marshfield Ave & 59th St                    | Residential | Englewood          |
| 561 | Damen Ave & 59th St                         | Residential | Englewood          |
| 561 | Damen Ave & 59th St                         | Residential | Englewood          |
| 562 | Racine Ave & 61st St                        | Residential | Woodlawn           |
| 562 | Racine Ave & 61st St                        | Residential | Woodlawn           |
| 563 | Ashland Ave & 63rd St                       | Residential | Englewood          |
| 564 | Racine Ave & 65th St                        | Residential | Englewood          |
| 564 | Racine Ave & 65th St                        | Residential | Englewood          |
| 565 | Ashland Ave & 66th St                       | Residential | Englewood          |
| 565 | Ashland Ave & 66th St                       | Residential | Englewood          |
| 566 | Ashland Ave & 69th St                       | Residential | Englewood          |
| 566 | Ashland Ave & 69th St                       | Residential | Englewood          |
| 567 | May St & 69th St                            | Residential | Englewood          |
| 567 | May St & 69th St                            | Residential | Englewood          |
| 569 | Woodlawn Ave & 75th St                      | Residential | Woodlawn           |
| 569 | Woodlawn Ave & 75th St                      | Residential | Woodlawn           |
| 570 | Evans Ave & 75th St                         | Residential | South Shore        |
| 571 | Vernon Ave & 75th St                        | Residential | Auburn Gresham     |
| 572 | State St & 76th St                          | Residential | Auburn Gresham     |
| 573 | State St & 79th St                          | Residential | Chatham            |
| 574 | Vernon Ave & 79th St                        | Residential | Auburn Gresham     |
| 575 | Cottage Grove Ave & 78th St                 | Residential | South Shore        |
| 576 | Greenwood Ave & 79th St                     | Residential | South Shore        |
| 577 | Stony Island Ave & South Chicago Ave        | Residential | South Shore        |
| 578 | Bennett Ave & 79th St                       | Residential | Auburn Gresham     |
| 579 | Phillips Ave & 79th St                      | Residential | Auburn Gresham     |
| 579 | Phillips Ave & 79th St                      | Residential | Auburn Gresham     |
| 580 | Exchange Ave & 79th St                      | Residential | Auburn Gresham     |
| 580 | Exchange Ave & 79th St                      | Residential | Auburn Gresham     |
| 581 | Commercial Ave & 83rd St                    | Residential | South Chicago      |
| 581 | Commercial Ave & 83rd St                    | Residential | South Chicago      |
| 582 | Phillips Ave & 83rd St                      | Residential | Auburn Gresham     |
| 582 | Phillips Ave & 83rd St                      | Residential | Auburn Gresham     |
| 583 | Stony Island Ave & 82nd St                  | Residential | South Shore        |
| 584 | Ellis Ave & 83rd St                         | Residential | Chatham            |
| 584 | Ellis Ave & 83rd St                         | Residential | Chatham            |
| 585 | Cottage Grove Ave & 83rd St                 | Residential | Auburn Gresham     |
| 586 | MLK Jr Dr & 83rd St                         | Residential | Chatham            |
| 586 | MLK Jr Dr & 83rd St                         | Residential | Chatham            |
| 587 | Wabash Ave & 83rd St                        | Residential | Washington Heights |
| 587 | Wabash Ave & 83rd St                        | Residential | Washington Heights |
| 588 | South Chicago Ave & 83rd St                 | Residential | South Chicago      |
| 589 | Milwaukee Ave & Cuyler Ave                  | Residential | Jefferson Park     |
| 590 | Kilbourn Ave & Irving Park Rd               | Residential | Jefferson Park     |
| 591 | Kilbourn Ave & Milwaukee Ave                | Residential | Jefferson Park     |
| 592 | Knox Ave & Montrose Ave                     | Residential | Jefferson Park     |
| 593 | Halsted St & 59th St                        | Residential | Englewood          |
| 593 | Halsted St & 59th St                        | Residential | Englewood          |
| 594 | Western Blvd & 48th Pl                      | Residential | Englewood          |
| 595 | Wabash Ave & 87th St                        | Residential | Washington Heights |
| 595 | Wabash Ave & 87th St                        | Residential | Washington Heights |
| 596 | Benson Ave & Church St                      | Residential | Evanston           |
| 597 | Chicago Ave & Washington St                 | Residential | Near West Side     |
| 598 | Elmwood Ave & Austin St                     | Residential | Oak Park           |
| 599 | Valli Produce - Evanston Plaza              | Residential | Evanston           |
| 600 | Dodge Ave & Church St                       | Residential | Evanston           |
| 601 | Central St Metra                            | Residential | Evanston           |
| 602 | Central St & Girard Ave                     | Residential | Evanston           |
| 603 | Chicago Ave & Sheridan Rd                   | Residential | Lincoln Park       |
| 604 | Sheridan Rd & Noyes St (NU)                 | Residential | Evanston           |
| 605 | University Library (NU)                     | Residential | Evanston           |
| 619 | Keystone Ave & Fullerton Ave                | Residential | Jefferson Park     |
| 620 | Orleans St & Chestnut St (NEXT Apts)        | Business    | Near North Side    |
| 621 | Aberdeen St & Randolph St                   | Business    | West Loop          |
| 622 | California Ave & Cortez St                  | Residential | Logan Square       |
| 623 | Michigan Ave & 8th St                       | Residential | South Loop         |
| 624 | Dearborn St & Van Buren St                  | Business    | Loop               |
| 625 | Chicago Ave & Dempster St                   | Residential | Evanston           |
| 626 | Delano Ct & Roosevelt Rd                    | Residential | Near South Side    |
| 627 | LaSalle Dr & Huron St                       | Business    | River North        |
| 628 | Walsh Park                                  | Business    | West Town          |
| 630 | Kildare Ave & Montrose Ave                  | Residential | Sauganash          |
| 631 | Malcolm X College                           | Residential | Near West Side     |
| 632 | Clark St & Newport St                       | Residential | Lincoln Park       |
| 635 | Fairbanks St & Superior St                  | Business    | River North        |
| 636 | Orleans St & Hubbard St                     | Business    | River North        |
| 637 | Wood St & Chicago Ave (*)                   | Residential | Near West Side     |
| 638 | Clinton St & Jackson Blvd                   | Business    | West Loop          |
| 639 | Lakefront Trail & Wilson Ave                | Residential | Uptown             |
| 640 | Bernard St & Elston Ave                     | Residential | Lincoln Park       |
| 641 | Central Park Ave & Bloomingdale Ave         | Residential | Logan Square       |
| 642 | Latrobe Ave & Chicago Ave                   | Residential | Austin             |
| 643 | Smith Park (*)                              | Business    | West Town          |
| 644 | Western Ave & Fillmore St (*)               | Residential | Garfield Park      |
| 645 | Archer (Damen) Ave & 37th St                | Residential | Brighton Park      |
| 646 | State St & 54th St                          | Residential | Washington Heights |
| 646 | State St & 54th St                          | Residential | Washington Heights |
| 647 | Elizabeth St & 59th St                      | Residential | Washington Heights |
| 648 | Carpenter St & 63rd St                      | Residential | Englewood          |
| 648 | Carpenter St & 63rd St                      | Residential | Englewood          |
| 649 | Stewart Ave & 63rd St (*)                   | Residential | Englewood          |
| 649 | Stewart Ave & 63rd St (*)                   | Residential | Englewood          |
| 650 | Eggleston Ave & 69th St (*)                 | Residential | Englewood          |
| 651 | Michigan Ave & 71st St                      | Residential | Washington Heights |
| 653 | Cornell Dr & Hayes Dr                       | Residential | Washington Park    |
| 654 | Racine Ave & Washington Blvd (*)            | Residential | Near West Side     |
| 655 | Hoyne Ave & Balmoral Ave                    | Residential | Lincoln Square     |
| 656 | Damen Ave & Walnut (Lake) St (*)            | Business    | West Loop          |
| 657 | Wood St & Augusta Blvd                      | Business    | West Town          |
| 658 | Leavitt St & Division St (*)                | Residential | Logan Square       |
| 659 | Leavitt St & Chicago Ave                    | Residential | Logan Square       |
| 660 | Sheridan Rd & Columbia Ave                  | Residential | Edgewater          |
| 661 | Evanston Civic Center                       | Residential | Evanston           |
| 662 | Dodge Ave & Mulford St                      | Residential | Evanston           |
| 663 | Lincolnwood Dr & Central St                 | Residential | Lincolnwood        |
| 664 | Leavitt St & Belmont Ave (*)                | Residential | Logan Square       |
| 665 | South Chicago Ave & Elliot Ave              | Residential | South Chicago      |
| 665 | South Chicago Ave & Elliot Ave              | Residential | South Chicago      |
| 666 | Cherry Ave & Blackhawk St                   | Residential | Lincoln Park       |
| 670 | MTL-ECO5.1-01                               | Residential | Near West Side     |
| 671 | HUBBARD ST BIKE CHECKING (LBS-WH-TEST)      | Business    | Near North Side    |
| 672 | Franklin St & Illinois St                   | Business    | River North        |
| 673 | Lincoln Park Conservatory                   | Residential | Lincoln Park       |
| 675 | HQ QR                                       | Residential | Near West Side     |

