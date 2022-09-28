getwd() #understanding my current working path
setwd("C:/Users/saiii/OneDrive/Desktop/McDaniel College/ANA 515/Week 6") #setting it to the new path

library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)

# 1


#saving the data to an object
storm_data <- read.csv("C:/Users/saiii/OneDrive/Desktop/McDaniel College/ANA 515/Week 6/storm1996.csv", header=TRUE, stringsAsFactors=FALSE)

head(storm_data) #making sure the data is correctly imported


# 2

storm_data_2 <- select(storm_data, 
                       BEGIN_DATE_TIME, 
                       END_DATE_TIME, 
                       EPISODE_ID, 
                       EVENT_ID,
                       STATE,
                       STATE_FIPS,
                       CZ_NAME, 
                       CZ_TYPE, 
                       CZ_FIPS, 
                       EVENT_TYPE, 
                       SOURCE,
                       BEGIN_LAT, 
                       BEGIN_LON, 
                       END_LAT, 
                       END_LON)

head(storm_data_2) #making sure the data is correctly imported


# 3

storm_data_2$BEGIN_DATE_TIME <- dmy_hms(storm_data_2$BEGIN_DATE_TIME) #converting column to date month year

storm_data_2$END_DATE_TIME <- dmy_hms(storm_data_2$END_DATE_TIME) #converting column to date month year

storm_data_2$BEGIN_DATE_TIME<- arrange(storm_data_2, BEGIN_DATE_TIME) #Arranging the data beginning year and month


# 4
storm_data_2$STATE <- str_to_title(storm_data_2$STATE) #Convert case of a string.

storm_data_2$CZ_NAME <- str_to_title(storm_data_2$CZ_NAME) #Convert case of a string.

storm_data_2$CZ_NAME #viewing the column to make sure its correct

storm_data_2$STATE #viewing the column to make sure its correct


# 5

storm_data_2 <- filter(storm_data_2, CZ_TYPE == "C") #filtering data of CZ_TYPE to only C values

storm_data_2 <- select(storm_data_2, -CZ_TYPE)


# 6 

storm_data_2$STATE_FIPS <- str_pad(storm_data_2$STATE_FIPS, width = 3, side = "left", pad ="0") #padding the column with 0

#padding the column with 0
storm_data_2$CZ_FIPS <- str_pad(storm_data_2$CZ_FIPS, width = 3, side = "left", pad ="0")


storm_data_2 <- unite(storm_data_2, FIPS_CODE, c("STATE_FIPS", "CZ_FIPS"), sep="") #removed 2 columns to make 1 new column

colnames(storm_data_2) #viewing my new df columns


# 7

storm_data_2 <- rename_all(storm_data_2, tolower)


storm_data_2 <- as_tibble(storm_data_2) # for nicer printing

colnames(storm_data_2) #shows all columns in lowercase



# 8

data("state")

us_state_info <- data.frame(state=state.name, region=state.region, area=state.area)



#9


table(storm_data_2$state) #how many times each state are in the column

new_set <- data.frame(table(storm_data_2$state)) #assigning a new df

head(new_set, 20)

new_set_1 <- rename(new_set, c("state" = "Var1"))


merged_df <- merge(x=new_set_1, y=us_state_info, by.x="state", by.y = "state")

head(merged_df)


#10

storm_plot <- ggplot(us_state_info, aes(x = area, y = merged_df$Freq)) + geom_point(aes(color = region)) +
  labs(x = "Land area (square miles)", y = "# of storm events in 1996")

storm_plot





