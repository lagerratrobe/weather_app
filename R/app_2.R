# app_2.R

# Shiny test - app.R

library(shiny)
library(DT)

mtcars <- mtcars[1:10,]
diamonds <- diamonds[1:10,]

ui <- fluidPage(
  titlePanel("MTCars or Diamonds"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "var", 
                  label = "Choose a table to display",
                  choices = c("mtcars", "diamonds"),
                  selected = "mtcars")
      ),
    mainPanel(
      h2("Selected Data"),
      tableOutput("table_data")
    )
  )
)

server <- function(input, output, session) {
  
  output$table_data <- renderTable({
    if (input$var == "mtcars") {
      mtcars
    } else {
      diamonds
    }
    })
}
  

# Run the app ----
shinyApp(ui = ui, server = server)
