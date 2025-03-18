
library(readr)
library(dplyr)
library(ggplot2)

#Import the dataset from the powerbI

clean_dataset <- read_csv("C:\\Users\\busal\\Desktop\\Cursos\\6.Google Data Analyst\\8. Project\\project\\PowerBI\\review_data\\CLEAN\\R\\data_clean.txt")
colnames(clean_dataset)

#-----------------------------DESCRIPTIVE ANALYSIS--------------------------------------

##*Trip Duration:* calculate mean, median, and standard deviation for trip durations for both annual members and casual riders.

duration_stats<- clean_dataset %>%
  group_by(member_casual) %>%
  summarize(mean_duration = mean(duration, na.rm = TRUE), 
            median_duration = median(duration, na.rm = TRUE),
            sd_duration = sd(duration, na.rm = TRUE))

cat("Duration Statistics:\n")
print(duration_stats)

#*Trip Frequency*: Calculate the total number of trips taken by each customer type for each month, 
#Analyze the trip frequency for each day of the week for both customer types.
#Compute the total number of trips taken by each customer type for each hour of the day.

trip_frequency_year <- clean_dataset %>%
  group_by(member_casual, year) %>%
  summarize(trip_count = n()) %>%
  arrange(member_casual, year)
cat("Trip Frequency by year:\n")
print(trip_frequency_year)

trip_frequency_month <- clean_dataset %>%
  group_by(member_casual, month_category) %>%
  summarize(trip_count = n()) %>%
  arrange(member_casual, month_category)
cat("Trip Frequency by Month:\n")
print(trip_frequency_month)

trip_frequency_day <- clean_dataset %>%
  group_by(member_casual, day_category) %>%
  summarize(trip_count = n()) %>%
  arrange(member_casual, day_category)
cat("Trip Frequency by type of day:\n")
print(trip_frequency_day)

###Time of the day

time_cat_breakdown <- clean_dataset %>%
  group_by(member_casual, time_category) %>%
  summarize(trip_count = n()) %>%
  arrange(member_casual, time_category)
cat("Trip Frequency by Time of the day :\n")
print(time_cat_breakdown)


#Check top/bottom 5 routes by customer type and year.

Top_5_routes <- clean_dataset %>%
  group_by(year, member_casual, Route) %>%  # Group by year, member_casual, and Route
  summarize(trip_count = n(), .groups = "drop") %>%  # Count trips and drop grouping for summarize
  arrange(year, member_casual, desc(trip_count)) %>%  # Sort by year, member type, and trip count
  group_by(year, member_casual) %>%  # Regroup by year and member type
  slice_head(n = 5)  # Select the top 5 routes per member type

cat("Top 5 Routes for Each Member Type:\n")
print(Top_5_routes)

#Bottom 5
Bottom_5_routes <- clean_dataset %>%
  group_by(year, member_casual, Route) %>%
  summarize(trip_count = n(), .groups = "drop") %>%  # Count trips and drop grouping for summarize
  arrange(year, member_casual, trip_count) %>%  # Sort by year, member type, and trip count in ascending order
  group_by(year, member_casual) %>%  # Regroup by year and member type
  slice_head(n = 5)  # Select the first 5 rows (least taken routes)

cat("Bottom 5 Least Taken Routes for Each Member Type:\n")
print(Bottom_5_routes)


#---------------------------------- COMPARATIVE ANALYSIS------------------------------------

#These steps will give you the chi-square test results for trip frequency comparisons
#The variable "day_category" has been paired with the member_casual for the Chi-square test.

contingency_table_day <- table(clean_dataset$member_casual, clean_dataset$day_category)
chi_square_day <- chisq.test(contingency_table_day)

cat("Chi-Square Test Results for Trip Frequency by Day of the Week:\n")
print(chi_square_day) 

#------------------------------------------VISUALIZATIONS--------------------------------------------------

##Trip duration --> box plots

ggplot(clean_dataset, aes(x = member_casual, y = duration)) +
  geom_boxplot() +
  labs(title = "Trip Duration by Customer Type", x = "Customer Type", y = "Duration (minutes)") +
  theme_minimal()

##Trip frequency --> stacked bar charts by user and type of day

####Type of day of the week

ggplot(clean_dataset, aes(x = day_category, fill = member_casual)) +
  geom_bar(position = "stack") +  # "stack" is the default for stacked bar charts
  labs(
    title = "Trip Frequency by Day of the Week and Customer Type in 2019",
    x = "Weekday/Weekend",
    y = "Number of Trips",
    fill = "Customer Type"  # Add a legend title for clarity
  ) +
  theme_minimal()


####By time of the day

ggplot(clean_dataset, aes(x = factor(time_category), fill = member_casual)) +
  geom_bar(position = "dodge") +
  labs(title = "Trip Frequency by Hour and Customer Type in Q1 2019", x = "Time of the day", y = "Number of Trips") +
  theme_minimal()

##Routes --> heatmaps

###Top 5 routes

# Filter for Top 5 Routes per Member User
top5_station_counts <- clean_dataset %>%
  group_by(member_casual, Route) %>%
  summarize(trip_count = n(), .groups = "drop") %>%  
  arrange(desc(trip_count)) %>%
  group_by(member_casual) %>%
  slice_head(n = 5)  # Select top 5 for each member_user

# Heatmap for Top 5 Routes
ggplot(top5_station_counts, aes(x = Route, y = member_casual, fill = trip_count)) +
  geom_tile() +
  labs(
    title = "Top 5 Routes",
    x = "Route",
    y = "Customer Type",
    fill = "Trip Count"
  ) +
  scale_fill_gradient(low = "yellow", high = "blue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


#### Bottom 5 Routes

# Filter for Bottom 5 Routes per Member User
bottom5_station_counts <- clean_dataset %>%
  group_by(member_casual, Route) %>%
  summarize(trip_count = n(), .groups = "drop") %>%  
  arrange(trip_count) %>%  # Sort by trip count in ascending order
  group_by(member_casual) %>%
  slice_head(n = 5)  # Select bottom 5 for each member_user

# Heatmap for Bottom 5 Routes
ggplot(bottom5_station_counts, aes(x = Route, y = member_casual, fill = trip_count)) +
  geom_tile() +
  labs(
    title = "Bottom 5 Routes",
    x = "Route",
    y = "Customer Type",
    fill = "Trip Count"
  ) +
  scale_fill_gradient(low = "pink", high = "green") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
