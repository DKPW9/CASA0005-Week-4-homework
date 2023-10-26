# Homework 4
# I need to join global gender inequality data to spatial data of the world
# I want to create a new column of difference in inequality between 2010 and 2019
# Then I want to share this on GitHub
# And I want to add my repository URL to the spreadsheet

install.packages("countrycode")
# Firstly I want to read in all my data
library(sf)
library(here)
library(dplyr)
library(tidyverse)
library(janitor)
library(countrycode)
library(tmap)
library(tmaptools)

gender <- read.csv("HDR21-22_Composite_indices_complete_time_series.csv")
                  header = TRUE, sep = ",", 
                  encoding = "latin1",
                  na = "n/a")
world <- st_read("World_Countries_Generalized.shp")

# I want to firstly work out the difference between join "gii_2019" and "gii_2010' 
# Then I want to add this as a column to the spatial data of the world
# gii_2019 = row 621
# gii_2010 = row 612

# DATA CLEANING
# First I'm going to make a data frame with only the relevant data
gii_condensed <- gender %>%
  dplyr::select(c(1,2,612,621)) %>%
  slice(1:195)

# Next I'm going to clean it to get rid of na values
gii_clean <- na.omit(gii_condensed)

# Finally I need to convert my countrycode in gii from ISO3 to ISO
# This will make it compatible when joining the datasets together
gii_clean$iso <- countrycode(gii_clean$iso3, origin = "iso3c", destination = "iso2c")

# View the modified data frame
gii_clean

# Next I'm going to clean the names in 'world' so the country label is lowercase (so join will work)
world <- world %>%
  clean_names()

# Next I need to calculate the difference between gii_2019 and gii_2010 and store this in a new column
gii_difference <- gii_clean %>%
  mutate(gii_difference = gii_2019 - gii_2010)

# Now I'm going to tidy it up so my gii dataset only contains the relevant data
gii_final <- gii_difference %>%
  dplyr::select(c(5,6))

# Now I want to join the datasets together using left join
gii_world <- world %>% 
  left_join(., 
            gii_final,
            by = c("iso" = "iso")) %>%
            na.omit()

# All done: time to share on GitHub 