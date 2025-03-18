#-----------------------------------------------------------------------------------------2019
#Check the first 2 rows
SELECT * FROM `cool-coral-453021-p4.2019_bikes.2019_bikes` LIMIT 2

#Create a back up table with the columns that we need based on the ride id and replace the headers to keep them in line with 2020
 
CREATE TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup` AS
SELECT 
  trip_id,
  from_station_id AS start_station_id,
  from_station_name AS start_station_name,
  start_time,
  to_station_id AS end_station_id,
  to_station_name AS end_station_name,
  end_time,
  usertype AS member_casual
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes`
ORDER BY trip_id;

#Check the first 2 rows
SELECT * FROM `cool-coral-453021-p4.2019_bikes.2019_bikes` LIMIT 2
SELECT * FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_backup` LIMIT 7

#Add columns 
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN year INTEGER,
ADD COLUMN start_month_name STRING,
ADD COLUMN end_month_name STRING,
ADD COLUMN start_day_name STRING,
ADD COLUMN end_day_name STRING,
ADD COLUMN start_hour INT64,
ADD COLUMN end_hour INT64;

#Add the year, month, day and hour from the time stamp

UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET
  year = EXTRACT(YEAR FROM start_time),
  start_month_name = FORMAT_TIMESTAMP('%B', start_time),
  end_month_name = FORMAT_TIMESTAMP('%B', end_time),
  start_day_name = FORMAT_TIMESTAMP('%A', start_time),
  end_day_name = FORMAT_TIMESTAMP('%A', end_time),
  start_hour = EXTRACT(HOUR FROM start_time), 
  end_hour = EXTRACT(HOUR FROM end_time) 
WHERE TRUE;

#Calculate the duration

##Create a new column
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN duration FLOAT64
##Calculate the duration and populate in the duration column
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET duration = TIMESTAMP_DIFF(TIMESTAMP(end_time), TIMESTAMP(start_time), MINUTE) 
WHERE TRUE;

#Create a new column to populate the duration category

##Add column
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN duration_category STRING;
##Add categories
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET duration_category = CASE 
  WHEN duration <= 5 THEN 'Less than 5 minutes'
  WHEN duration <= 10 THEN 'Less than 10 minutes'
  WHEN duration <= 15 THEN 'Less than 15 minutes'
  WHEN duration <= 30 THEN 'Less than 30 minutes'
  WHEN duration <= 45 THEN 'Less than 45 minutes'
  WHEN duration <= 60 THEN 'Less than 1 hour'
  WHEN duration <= 90 THEN 'Less than 1.5 hours'
  WHEN duration <= 120 THEN 'Less than 2 hours'
  ELSE 'More'
END
WHERE TRUE;

#Add the day category

##Add a new column were we add the category for the day weekend (Saturday or Sunday) or weekday (for the rest)
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN day_category STRING;
##Add the classification
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET day_category = CASE
  -- Both start and end days are weekdays
  WHEN start_day_name NOT IN ('Saturday', 'Sunday') AND end_day_name NOT IN ('Saturday', 'Sunday') THEN 'Weekday'
  -- Both start and end days are weekends
  WHEN start_day_name IN ('Saturday', 'Sunday') AND end_day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
  -- Start day is Friday and end day is Saturday
  WHEN start_day_name = 'Friday' AND end_day_name = 'Saturday' THEN 'Friday-Saturday'
  -- Start day is Sunday and end day is Monday
  WHEN start_day_name = 'Sunday' AND end_day_name = 'Monday' THEN 'Sunday-Monday'
  -- Default case
  ELSE 'Unclassified'
END
WHERE TRUE;
##Check again the categories
SELECT DISTINCT day_category
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`;
##shows unclassified

#Add the hour classification
##Add the hour_category column to the table
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN hour_category STRING;
##Update the categories
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET hour_category = CASE
  WHEN start_hour BETWEEN 6 AND 11 AND end_hour BETWEEN 6 AND 11 THEN 'Morning'
  WHEN start_hour BETWEEN 12 AND 17 AND end_hour BETWEEN 12 AND 17 THEN 'Afternoon'
  WHEN start_hour BETWEEN 18 AND 21 AND end_hour BETWEEN 18 AND 21 THEN 'Evening'
  WHEN (start_hour >= 22 OR start_hour < 6) AND (end_hour >= 22 OR end_hour < 6) THEN 'Night'
  WHEN (start_hour >= 22 OR start_hour < 6) AND end_hour BETWEEN 6 AND 11 THEN 'Night-Morning'
  WHEN start_hour BETWEEN 6 AND 11 AND end_hour BETWEEN 12 AND 17 THEN 'Morning-Afternoon'
  WHEN start_hour BETWEEN 12 AND 17 AND end_hour BETWEEN 18 AND 21 THEN 'Afternoon-Evening'
  WHEN start_hour BETWEEN 18 AND 21 AND (end_hour >= 22 OR end_hour < 6) THEN 'Evening-Night'
  ELSE 'Unclassified'
END
WHERE TRUE;

#Add the month category
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN month_category STRING;

#Add the day number
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN start_day INT64;

ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ADD COLUMN end_day INT64;

##Extract the day
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET start_day = EXTRACT(DAY FROM start_time),
    end_day = EXTRACT(DAY FROM end_time)
WHERE TRUE;

##Add the categories
UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET 
  month_category = CASE
    WHEN start_day IN (28, 30, 31) AND end_day = 1 THEN CONCAT(start_month_name, '-', end_month_name)
    ELSE start_month_name
  END
WHERE TRUE;

##Check again the categories
SELECT DISTINCT month_category
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`;

#Update the member_casual column to map that to the 2020 labelling.

UPDATE `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
SET member_casual = CASE 
  WHEN member_casual = 'Customer' THEN 'Casual'
  WHEN member_casual = 'Subscriber' THEN 'Member'
END
WHERE member_casual IN ('Customer', 'Subscriber');
##Check again the categories
SELECT DISTINCT member_casual
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`;

#------------------------------------------------------------------------2020
SELECT * FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_source` LIMIT 2

#Create a back up table with the columns that we need based on the ride id
CREATE TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`  AS
SELECT 
  ride_id,
  started_at,
  ended_at,
  start_station_id,
  start_station_name,
  end_station_id,
  end_station_name,
  member_casual,
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_source` 
ORDER BY ride_id;
#Check the first 2 rows
SELECT * FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_source` LIMIT 2
SELECT * FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_backup` LIMIT 2
#Add columns 
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN year INTEGER,
ADD COLUMN start_month_name STRING,
ADD COLUMN end_month_name STRING,
ADD COLUMN start_day_name STRING,
ADD COLUMN end_day_name STRING,
ADD COLUMN start_hour INT64,
ADD COLUMN end_hour INT64;

#Add the year, month, day and hour from the time stamp
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET
  year = EXTRACT(YEAR FROM started_at),
  start_month_name = FORMAT_TIMESTAMP('%B', started_at),
  start_day_name = FORMAT_TIMESTAMP('%A', started_at),
  start_hour = EXTRACT(HOUR FROM started_at),
  end_day_name = FORMAT_TIMESTAMP('%A', ended_at),
  end_month_name = FORMAT_TIMESTAMP('%B', ended_at),
  end_hour = EXTRACT(HOUR FROM ended_at) 
where true;

#Calculate the duration

##Create a new column
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN duration FLOAT64
##Calculate the duration and populate in the duration column
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET duration = TIMESTAMP_DIFF(TIMESTAMP(ended_at), TIMESTAMP(started_at), MINUTE) 
WHERE TRUE;
#Create a new column to populate the duration category

##Add column
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN duration_category STRING;
##Add categories
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET duration_category = CASE 
  WHEN duration <= 5 THEN 'Less than 5 minutes'
  WHEN duration <= 10 THEN 'Less than 10 minutes'
  WHEN duration <= 15 THEN 'Less than 15 minutes'
  WHEN duration <= 30 THEN 'Less than 30 minutes'
  WHEN duration <= 45 THEN 'Less than 45 minutes'
  WHEN duration <= 60 THEN 'Less than 1 hour'
  WHEN duration <= 90 THEN 'Less than 1.5 hours'
  WHEN duration <= 120 THEN 'Less than 2 hours'
  ELSE 'More'
END
WHERE TRUE;
#Add the day category

##Add a new column were we add the category for the day weekend (Saturday or Sunday) or weekday (for the rest)
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN day_category STRING;
##Add the classification
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET day_category = CASE
  -- Both start and end days are weekdays
  WHEN start_day_name NOT IN ('Saturday', 'Sunday') AND end_day_name NOT IN ('Saturday', 'Sunday') THEN 'Weekday'
  -- Both start and end days are weekends
  WHEN start_day_name IN ('Saturday', 'Sunday') AND end_day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
  -- Start day is Friday and end day is Saturday
  WHEN start_day_name = 'Friday' AND end_day_name = 'Saturday' THEN 'Friday-Saturday'
  -- Start day is Sunday and end day is Monday
  WHEN start_day_name = 'Sunday' AND end_day_name = 'Monday' THEN 'Sunday-Monday'
  -- Default case
  ELSE 'Unclassified'
END
WHERE TRUE;
##Check again the categories
SELECT DISTINCT day_category
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`;
##shows unclassified

#Add the hour classification
##Add the hour_category column to the table
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN hour_category STRING;
##Update the categories
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET hour_category = CASE
  WHEN start_hour BETWEEN 6 AND 11 AND end_hour BETWEEN 6 AND 11 THEN 'Morning'
  WHEN start_hour BETWEEN 12 AND 17 AND end_hour BETWEEN 12 AND 17 THEN 'Afternoon'
  WHEN start_hour BETWEEN 18 AND 21 AND end_hour BETWEEN 18 AND 21 THEN 'Evening'
  WHEN (start_hour >= 22 OR start_hour < 6) AND (end_hour >= 22 OR end_hour < 6) THEN 'Night'
  WHEN (start_hour >= 22 OR start_hour < 6) AND end_hour BETWEEN 6 AND 11 THEN 'Night-Morning'
  WHEN start_hour BETWEEN 6 AND 11 AND end_hour BETWEEN 12 AND 17 THEN 'Morning-Afternoon'
  WHEN start_hour BETWEEN 12 AND 17 AND end_hour BETWEEN 18 AND 21 THEN 'Afternoon-Evening'
  WHEN start_hour BETWEEN 18 AND 21 AND (end_hour >= 22 OR end_hour < 6) THEN 'Evening-Night'
  ELSE 'Unclassified'
END
WHERE TRUE;

#Add the month category
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN month_category STRING;

#Add the day number
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN start_day INT64;

ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ADD COLUMN end_day INT64;

##Extract the day
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET start_day = EXTRACT(DAY FROM started_at),
    end_day = EXTRACT(DAY FROM ended_at)
WHERE TRUE;

##Add the categories
UPDATE `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
SET 
  month_category = CASE
    WHEN start_day IN (28, 30, 31) AND end_day = 1 THEN CONCAT(start_month_name, '-', end_month_name)
    ELSE start_month_name
  END
WHERE TRUE;

#Create a table to be cleaned
CREATE TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN` AS
SELECT 
*
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_backup`
ORDER BY ride_id;
