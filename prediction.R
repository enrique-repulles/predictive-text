

term.data<-readRDS(file = "termdata.RDS")


training <- term.data[sample(nrow(term.data), size=1000),] # para probar que compilan bien
test <- term.data[sample(nrow(term.data), size=100),] 
rm(term.data)


# Primera versión simple: busca el que aparece con más frecuencia

# "memorization" method
predict_simple <- function (previous.words)
{
  
  #clean input
  previous.words <- stripWhitespace(trimws(previous.words))
  # predict
  candidates <- training[training$gram.head==previous.words,]
  if (nrow(candidates)>0)
  {
    result<-candidates[which.max(candidates$freq), ]$gram.tail  
  }
  else 
  {
    result<-NA
  }
}

predict_simple ("to dox")


# simple evaluation

evaluate <- function(dataset)
{
 
  predicted<-sapply (X = dataset$gram.head, FUN=predict_simple) 
  names(predicted)<-NULL
  evaluation.result<-data.frame(previous=dataset$gram.head, correct=dataset$gram.tail, predicted=predicted) 
  evaluation.result$previous<-as.character(evaluation.result$previous) 
  evaluation.result$correct<-as.character(evaluation.result$correct) 
  evaluation.result$predicted<-as.character(evaluation.result$predicted) 
  evaluation.result$result<-(evaluation.result$correct==evaluation.result$predicted) 
  evaluation.result$result<-(evaluation.result$result & !is.na(evaluation.result$result) )
  evaluation.result
}

tt<-sapply (X = training$gram.head, FUN=predict_simple) 

evaluation.train<-evaluate(training)
evaluation.test<-evaluate(test)



