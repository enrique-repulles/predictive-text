
library(shiny)
library(wordcloud)

train.data <<- readRDS(file="training_data.RDS")

source("main.R")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  observeEvent(input$submit, {
    if (nchar(input$query)>0)
    {
      result=findCandidates(input$query)
      result$candidates<-result$candidates[!is.na(result$candidates$prob),]
      output$bestCandidate<-renderText(c("<br>Predicted word: <b> ",result$bestCandidate," </b></br><br></br>"))
      output$word.cloud<- renderPlot(wordcloud(words=result$candidates$word, freq=result$candidates$prob))
      output$title1<-renderText("<h3>Prediction:</h3>")
      output$title2<-renderText("<h3>cloud of candidates:</h3>")
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
