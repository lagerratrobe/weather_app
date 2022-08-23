# Shiny test - app.R

library(shiny)
library(DT)
source("./R/scratch.R")

weather_data <- getWeatherData()
seattle <- getStationData(weather_data, stations = "KWASEATT2743")
seattle_temps <- getVariableData(seattle, vars = "imperial.temp")
daily_seattle_temps <- getDailyTemps(df = seattle_temps)

##### ---- Define UI ---- #####
ui <- fluidPage(
  titlePanel("Daily Temperatures"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput(inputId = "dates", 
                     label = h3("Date range"),
                     start = "2022-08-05",
                     end = "2022-08-22"
      )
    ),
    mainPanel(
      h2("Temperatures"),
      DTOutput("table_data")
    )
  )
)

##### ---- Define server logic ---- #####
server <- function(input, output, session) {
  
  output$table_data <- renderDT(rownames = TRUE, 
                                options = list(bPaginate = FALSE, 
                                               dom = 't'), 
                                {daily_seattle_temps %>% 
                                    filter(date >= input$dates[1] & 
                                             date <= input$dates[2])
                                })
}

# Run the app ----
shinyApp(ui = ui, server = server)


