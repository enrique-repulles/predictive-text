
# The libraries needed to run the code
library("NLP")
library("tm")
library("ggplot2")
library("knitr")


sampleFileBUENO<-function(myfilename, sample.proportion)
{
  path<-paste0("./raw_data/final/en_US/",myfilename)
  out.path<-paste0("./clean_data/",strsplit(myfilename,split = ".txt")[[1]],".sampled.txt")
  raw.data = readLines(path,warn = FALSE,skipNul = TRUE);
  sample<-1==rbinom(n=length(raw.data), p=sample.proportion,size=1)
  data<-raw.data[sample]
  # saveRDS(object = data, file = out.path)
  writeLines(data,con=out.path)
  
}


sampleFile<-function(myfilename, sample.no.se.usa)
{
  path<-paste0("./raw_data/final/en_US/",myfilename)
  out.path<-paste0("./clean_data/",strsplit(myfilename,split = ".txt")[[1]],".sampled.txt")
  raw.data = readLines(path,warn = FALSE,skipNul = TRUE,n = 3);
  # saveRDS(object = data, file = out.path)
  writeLines(raw.data,con=out.path)
}



sampleFileBUENO("en_US.blogs.txt", .01)
sampleFileBUENO("en_US.news.txt", .01)
sampleFileBUENO("en_US.twitter.txt", .01)

corpus.source<-DirSource("./clean_data/")
corpus.source
corpus<-VCorpus(corpus.source, readerControl = list(reader=readPlain,language = "en"))
summary(corpus)




  # Read the list of offensive words 
  offensive.words<-readLines("raw_data/Terms-to-Block.csv")
  offensive.words<-offensive.words[5:length(offensive.words)]
  offensive.words<-gsub("[\"]","",offensive.words)
  offensive.words<-gsub("[,]","",offensive.words)  







corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus ,stripWhitespace)
corpus <- tm_map(corpus, tolower)
# corpus <- tm_map(corpus, removeWords, stopwords("english")) # quitar
corpus <- tm_map(corpus, removeWords, offensive.words)


#Tokenizin all ngrams in one iteration

MultigramTokenizer<-  function(x) {
  words<-words(x)
  bigrams<-ngrams(words(x),2)
  trigrams<-ngrams(words(x),3)
  
  words<-unlist(lapply(words, paste, collapse = " "), use.names = FALSE)  
  bigrams<-unlist(lapply(bigrams, paste, collapse = " "), use.names = FALSE)  
  trigrams<-unlist(lapply(trigrams, paste, collapse = " "), use.names = FALSE)  
  
  
  c(words,bigrams, trigrams)
  
}


tmd<-TermDocumentMatrix(corpus, control=list(tokenize=MultigramTokenizer))



#Training data construction

#totalTMD<-rbind(unigramMatrix,bigramMatrix, trigramMatrix)
#attributes(totalTMD) <- attributes(bigramMatrix)
total.frequencies<-apply(as.matrix(tmd), FUN=sum, MARGIN=1) # Add for all documents
# El term es el índice

get.gram.head <- function (s)
{
  paste(s[1:length(s)-1],collapse = " ")
}


get.gram.tail <- function (s)
{
  s[length(s)]
}


term.data <- data.frame(
  term=names(total.frequencies),
  freq=total.frequencies,
  gram.size=sapply(strsplit(names(total.frequencies)," "), FUN =length),
  gram.head=sapply(strsplit(names(total.frequencies)," "), FUN =get.gram.head),
  gram.tail=sapply(strsplit(names(total.frequencies)," "), FUN =get.gram.tail)
)


term.data$term <- as.character(term.data$term)
term.data$gram.head <- as.character(term.data$gram.head)
term.data$gram.tail <- as.character(term.data$gram.tail)

saveRDS(object = term.data, file = "termdata.RDS")



#Cleanup 

rm(corpus, corpus.source, tmd, total.frequencies, term.data)

