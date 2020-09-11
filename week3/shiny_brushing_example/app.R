# to run app: runApp("shiny_brushing_example")

library(shiny)
library(tidyverse)
library(datasets)

mtcars2 <- mtcars %>%
  select(mpg, cyl, wt)

###################################### UI ######################################
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Brushing Example"),
  
  plotOutput(outputId = "plot1", brush = brushOpts(id = "plot1_brush")),
  plotOutput(outputId = "plot2"),
  tableOutput(outputId = "datatable")
)

#################################### Server ####################################
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Reactive that returns the whole dataset if there is no brush
  selectedData <- reactive({
    data <- brushedPoints(mtcars2, input$plot1_brush)
    if (nrow(data) == 0)
      data <- mtcars2
    data
  })
  
  output$plot1 <- renderPlot({
    ggplot(mtcars2) +
      aes(x = wt, y = mpg) +
      geom_point()
  })
  
  output$plot2 <- renderPlot({
    ggplot(selectedData()) +
      aes(x = factor(cyl), y = mpg) +
      geom_boxplot()
  })
  
  output$datatable <- renderTable({
    selectedData()
  })
  
}

############################## Shiny App Function ##############################
shinyApp(ui = ui, server = server)


