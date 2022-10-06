# New Comment Line

# scratch.R - Utility function developemnt for weather_app
library(dplyr)
library(lubridate)

# setup - Pull data in from Github and make it ready for consumption in Shiny
getWeatherData <- function() {
  df <- readRDS(url("https://github.com/lagerratrobe/weather_station/raw/main/Data/station_obs.RDS"))
  # Convert obsTimeLocal to proper Posix time object
  df <- mutate(df,
               obsTimeLocal = lubridate::parse_date_time(
                 obsTimeLocal,
                 "Ymd HMS",
                 tz = "UTC",
                 truncated = 0,
                 quiet = FALSE,
                 exact = FALSE) -> df)
  return(df)
} 

# Step 1 - Filter data by 1 or more stationID
getStationData <- function( 
    df = NULL,
    stations = NULL) {
  return(dplyr::filter(df, stationID %in% stations))
}

# Step 2 - Subset to specific variables. Always include:
# - stationID, 
# - obsTimeLocal,
# in addition to variable
getVariableData <- function(
    df = NULL,
    vars = NULL) {
  df <- select(df,
               stationID,
               obsTimeLocal,
               all_of(vars))
  
  return(df)
}

# Step 3 - Extract highest values per day
getDailyTemps <- function(
    df = NULL
) {
  df <- 
    group_by(df,
             stationID,
             'date' = lubridate::date(obsTimeLocal)) %>% 
    summarise(min_temp = min(imperial.temp),
              max_temp = max(imperial.temp))
  return(df)
}
############### Main - GSD ###############################
#library(profvis)

#profvis({
  weather_data <- getWeatherData()
  # stations <- unique(weather_data$stationID)
  # # 
  # # Filter data to distinct StationIDs
  seattle <- getStationData(weather_data, stations = "KWASEATT2743")
  # # 
  # # Get Temp data
  seattle_temps <- getVariableData(seattle, vars = "imperial.temp")
  # # tail(seattle_temps)
  # # 
  # # Daily Min and Max temps
  daily_seattle_temps <- getDailyTemps(df = seattle_temps)
  # # tail(daily_seattle_temps)
#})

