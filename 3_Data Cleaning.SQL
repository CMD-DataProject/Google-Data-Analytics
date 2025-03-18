#---------------------------------------------------------2019
  
CREATE TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN` AS
SELECT 
  *,
  CAST(trip_id AS STRING) as ride_id
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_backup`
ORDER BY ride_id;

SELECT * FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN` LIMIT 6

##Remove columns that are not requiered

##Remove columns that are not relevant
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`
DROP COLUMN start_time,
DROP COLUMN end_time,
DROP COLUMN start_day,
DROP COLUMN end_day,
DROP COLUMN start_month_name,
DROP COLUMN end_month_name,
DROP COLUMN start_day_name,
DROP COLUMN end_day_name,
DROP COLUMN start_hour,
DROP COLUMN end_hour

##Check and remove blanks or nulls
DELETE FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`
WHERE
  trip_id IS NULL
  OR start_station_id IS NULL
  OR start_station_name IS NULL
  OR end_station_id IS NULL
  OR end_station_name IS NULL
  OR member_casual IS NULL
  OR year IS NULL
  OR duration IS NULL
  OR duration_category IS NULL
  OR day_category IS NULL
  OR hour_category IS NULL
  OR month_category IS NULL;
###two rows removed

##Remove from the duration category less than 5 minutes and more
DELETE FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`
WHERE duration_category IN ('Less than 5 minutes', 'More');

##Remove duplicates
SELECT
  ride_id,
  COUNT(*) AS duplicate_count
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`
GROUP BY ride_id
HAVING COUNT(*) > 1;
##No duplicates

#Drop trip_id
ALTER TABLE `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`
DROP COLUMN trip_id

#Count the initial rows
SELECT COUNT(*)
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes`;
##365071

#Count the final rows
SELECT COUNT(*)
FROM `cool-coral-453021-p4.2019_bikes.2019_bikes_CLEAN`;
##270696







#---------------------------------------------------------2020

SELECT * FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN` LIMIT 3

##Remove columns that are not requiered

##Remove columns that are not relevant
ALTER TABLE `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN`
DROP COLUMN started_at,
DROP COLUMN ended_at,
DROP COLUMN start_day,
DROP COLUMN end_day,
DROP COLUMN start_month_name,
DROP COLUMN end_month_name,
DROP COLUMN start_day_name,
DROP COLUMN end_day_name,
DROP COLUMN start_hour,
DROP COLUMN end_hour

##Check and remove blanks or nulls
DELETE FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN`
WHERE
  ride_id IS NULL
  OR start_station_id IS NULL
  OR start_station_name IS NULL
  OR end_station_id IS NULL
  OR end_station_name IS NULL
  OR member_casual IS NULL
  OR year IS NULL
  OR duration IS NULL
  OR duration_category IS NULL
  OR day_category IS NULL
  OR hour_category IS NULL
  OR month_category IS NULL;
###deleted 1 row
##Remove from the duration category less than 5 minutes and more
DELETE FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN`
WHERE duration_category IN ('Less than 5 minutes', 'More');
###125885 removed
##Remove duplicates
SELECT
  ride_id,
  COUNT(*) AS duplicate_count
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN`
GROUP BY ride_id
HAVING COUNT(*) > 1;
#####0 rows duplicated

#Count the initial rows
SELECT COUNT(*)
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_source`;
##426887

#Count the final rows
SELECT COUNT(*)
FROM `cool-coral-453021-p4.2020_bikes.2020_bikes_CLEAN`;
###301001
