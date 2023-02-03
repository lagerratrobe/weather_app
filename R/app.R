# Shiny test - app.R

library(shiny)
library(DT)
library(dplyr)
source("scratch.R")

weather_data <- getWeatherData()

##### ---- Define UI ---- #####
ui <- fluidPage(
  titlePanel("Daily Temperatures"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "station",
                  label = h4("Station"),
                  choices = unique(weather_data$stationID),
                  selected = "KWASEATT2743"),
      dateRangeInput(inputId = "dates", 
                     label = h4("Date range"),
                     start = min(weather_data$obsTimeUtc),
                     end = max(weather_data$obsTimeUtc)
      )),
    mainPanel(
      h2("Daily Highs and Lows"),
      DTOutput("table_data")
    )
  )
)

##### ---- Define server logic ---- #####
server <- function(input, output, session) {
  
  station_data <- reactive({
    weather_data[weather_data$stationID == input$station,]
  })
  
  temp_data <- reactive({
    getVariableData(station_data(), vars = "imperial.temp")
  })
  
  daily_min_max_temps <- reactive({
    getDailyTemps(df = temp_data()) %>% 
      filter(date >= input$dates[1] & 
               date <= input$dates[2])
  })
  
  output$table_data <- renderDT(rownames = FALSE,
                                server = FALSE,
                                options = list(bPaginate = FALSE, 
                                               dom = 't',
                                               ordering=F), 
                                {daily_min_max_temps()
                                })
}

# Run the app ----
shinyApp(ui = ui, server = server)


