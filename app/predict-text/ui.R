

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text prediction"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput("query", "Insert text: ", value = "", width = NULL, placeholder = NULL),
       actionButton("submit", "predict", icon = NULL, width = NULL)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       textOutput("bestCandidate"),
       tableOutput("candidates")
       
    )
  )
))
