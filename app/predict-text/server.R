
library(shiny)

setwd("../..")
train.data <<- readRDS(file="train.data.RDS")
source("main.R")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  observeEvent(input$submit, {
    if (nchar(input$query)>0)
    {
      result=predict.word(input$query)
      output$bestCandidate<-renderText(result$word)
      output$candidates<-renderTable(result$candidates)
    }
    
  }
  )
  
})

findCandidates<-function (query)
{
  prediction  <-predict.word (query) 
  list(
    candidates= prediction$candidates[,c("word","prob")],
    bestCandidate=as.character(prediction$word)
  )
  
}
