# to run app: runApp("shiny_example")
# to see other pre-existing Shiny examples:
  # runExample("01_hello")      # a histogram
  # runExample("02_text")       # tables and data frames
  # runExample("03_reactivity") # a reactive expression
  # runExample("04_mpg")        # global variables
  # runExample("05_sliders")    # slider bars
  # runExample("06_tabsets")    # tabbed panels
  # runExample("07_widgets")    # help text and submit buttons
  # runExample("08_html")       # Shiny app built from HTML
  # runExample("09_upload")     # file upload wizard
  # runExample("10_download")   # file download wizard
  # runExample("11_timer")      # an automated timer
# to see standard Shiny widgets: 
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson3/

library(shiny)

###################################### UI ######################################
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

#################################### Server ####################################
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

############################## Shiny App Function ##############################
shinyApp(ui = ui, server = server)


## to run app: runApp("shiny_example")

