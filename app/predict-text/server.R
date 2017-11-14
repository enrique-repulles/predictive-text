
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  observeEvent(input$submit, {
    result=findCandidates(input$query)
    output$bestCandidate<-renderText(result$bestCandidate)
    output$candidates<-renderTable(result$candidates)
  }
  )
  
})

findCandidates<-function (query)
{
  candidates<-data.frame(candidates=paste(query,c("uno","dos","tres")), probability=rnorm(n = 3))
  bestCandidate <- paste0(query,"BEST",collapse = " ")
  list(
    candidates=candidates,
    bestCandidate=bestCandidate
  )
  
}
