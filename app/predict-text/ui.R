

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
        helpText('Usage: insert the  sentence in the "Insert text" box and press the "predict" button. The prediction will be shown, and also a word-cloud of the possible candidates.'),
        htmlOutput("title1"),
        htmlOutput("bestCandidate"),
        htmlOutput("title2"),
        plotOutput("word.cloud"),
        helpText("Sources and more information in: "),
        a('github.com/enrique-repulles/predictive-text', href="https://github.com/enrique-repulles/predictive-text")
    )
  )
))
