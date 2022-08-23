# shiny_scratch.R

library(shiny)
library(dplyr)
library(ggplot2)
source("R/scratch.R")

# Plot temps for Seattle
weather_data <- getWeatherData()
seattle_weather <- getStationData(weather_data, stations = "KWASEATT2743")
seattle_temps <- getVariableData(seattle_weather, vars = "imperial.temp")
daily_seattle_temps <- getDailyTemps(df = seattle_temps)
# Trim off 1st and last temps
daily_seattle_temps <- daily_seattle_temps[2:(nrow(daily_seattle_temps) -1),]

# Figure out some plots that make sense
daily_seattle_temps %>% ggplot() +
  geom_line(mapping = aes(x = date, y = max_temp), color = 'red') +
  geom_line(mapping = aes(x = date, y = min_temp), color = 'blue')

# Goal 1: slider to control what date range is shown
